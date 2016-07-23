{-# Language OverloadedStrings #-}

module Client.EventLoop
  ( eventLoop
  ) where

import           Client.Commands
import           Client.ConnectionState
import           Client.Image
import           Client.Message
import           Client.NetworkConnection
import           Client.State
import           Client.Window
import           Control.Concurrent.STM
import           Control.Exception
import           Control.Lens
import           Control.Monad
import           Data.Ord
import           Data.List
import           Data.Time
import           Data.Foldable
import           Data.ByteString (ByteString)
import           Graphics.Vty
import           Irc.Identifier
import           Irc.Message
import           Irc.RawIrcMsg
import           Irc.UserInfo
import qualified Client.EditBox     as Edit
import qualified Data.Text as Text
import qualified Data.Map as Map
import qualified Data.IntMap as IntMap


data ClientEvent
  = VtyEvent Event
  | NetworkEvent NetworkEvent
  | TimerEvent Int TimedAction


getEvent :: ClientState -> IO ClientEvent
getEvent st =
  do timer <- prepareTimer
     atomically $
       asum [ timer
            , VtyEvent     <$> readTChan vtyEventChannel
            , NetworkEvent <$> readTChan (view clientEvents st)
            ]
  where
    vtyEventChannel = _eventChannel (inputIface (view clientVty st))

    possibleTimedEvents =
      [ (networkId, runAt, action)
           | (networkId, cs) <- views clientConnections IntMap.toList st
           , Just (runAt, action) <- [nextTimedAction cs]
           ]

    earliestEvent
      | null possibleTimedEvents = Nothing
      | otherwise = Just (minimumBy (comparing (\(_,runAt,_) -> runAt)) possibleTimedEvents)

    prepareTimer =
      case earliestEvent of
        Nothing -> return retry
        Just (networkId,runAt,action) ->
          do now <- getCurrentTime
             let microsecs = truncate (1000000 * diffUTCTime runAt now)
             var <- registerDelay (max 0 microsecs)
             return $ do ready <- readTVar var
                         unless ready retry
                         return (TimerEvent networkId action)

eventLoop :: ClientState -> IO ()
eventLoop st0 =
  do st1 <- clientTick st0
     let vty = view clientVty st
         (pic, st) = clientPicture st1

     update vty pic

     event <- getEvent st
     case event of
       TimerEvent networkId action  -> doTimerEvent networkId action st
       VtyEvent vtyEvent         -> doVtyEvent vtyEvent st
       NetworkEvent networkEvent ->
         case networkEvent of
           NetworkLine  network time line -> doNetworkLine network time line st
           NetworkError network time ex   -> doNetworkError network time ex st
           NetworkClose network time      -> doNetworkClose network time st

doNetworkClose :: NetworkId -> ZonedTime -> ClientState -> IO ()
doNetworkClose networkId time st =
  let (cs,st') = removeNetwork networkId st
      msg = ClientMessage
              { _msgTime    = time
              , _msgNetwork = view csNetwork cs
              , _msgBody    = ExitBody
              }
  in eventLoop $ recordNetworkMessage msg st'


doNetworkError :: NetworkId -> ZonedTime -> SomeException -> ClientState -> IO ()
doNetworkError networkId time ex st =
  let (cs,st') = removeNetwork networkId st
      msg = ClientMessage
              { _msgTime    = time
              , _msgNetwork = view csNetwork cs
              , _msgBody    = ErrorBody (show ex)
              }
  in eventLoop $ recordNetworkMessage msg st'

doNetworkLine :: NetworkId -> ZonedTime -> ByteString -> ClientState -> IO ()
doNetworkLine networkId time line st =
  case view (clientConnections . at networkId) st of
    Nothing -> error "doNetworkLine: Network missing"
    Just cs ->
      let network = view csNetwork cs in
      case parseRawIrcMsg (asUtf8 line) of
        Nothing ->
          do let msg = ClientMessage
                        { _msgTime = time
                        , _msgNetwork = network
                        , _msgBody = ErrorBody ("Malformed message: " ++ show line)
                        }
             eventLoop (recordNetworkMessage msg st)

        Just raw ->
          do let irc = cookIrcMsg raw
                 time' = case view msgServerTime raw of
                           Nothing -> time
                           Just stime -> utcToZonedTime (zonedTimeZone time) stime
                 msg = ClientMessage
                         { _msgTime = time'
                         , _msgNetwork = network
                         , _msgBody = IrcBody irc
                         }
                 myNick = view csNick cs
                 target = msgTarget myNick irc

             -- record messages *before* applying the changes
             let (msgs, st')
                    = traverseOf
                        (clientConnection network)
                        (applyMessage time irc)
                    $ recordIrcMessage network target msg
                    $ st

             traverse_ (sendMsg cs) msgs
             eventLoop st'

doVtyEvent :: Event -> ClientState -> IO ()
doVtyEvent vtyEvent st =
  case vtyEvent of
    EvKey k modifier -> doKey k modifier st
    EvResize{} -> -- ignore event parameters due to raw TChan use
      do let vty = view clientVty st
         refresh vty
         (w,h) <- displayBounds (outputIface vty)
         eventLoop $ set clientWidth w
                   $ set clientHeight h st
    _                -> eventLoop st

doKey :: Key -> [Modifier] -> ClientState -> IO ()
doKey key modifier st =
  let changeInput f = eventLoop (over clientTextBox f st) in
  case modifier of
    [MCtrl] ->
      case key of
        KChar 'd' -> changeInput Edit.delete
        KChar 'a' -> changeInput Edit.home
        KChar 'e' -> changeInput Edit.end
        KChar 'u' -> changeInput Edit.killHome
        KChar 'k' -> changeInput Edit.killEnd
        KChar 'y' -> changeInput Edit.paste
        KChar 'w' -> changeInput (Edit.killWord True)
        KChar 'b' -> changeInput (Edit.insert '\^B')
        KChar 'c' -> changeInput (Edit.insert '\^C')
        KChar ']' -> changeInput (Edit.insert '\^]')
        KChar '_' -> changeInput (Edit.insert '\^_')
        KChar 'o' -> changeInput (Edit.insert '\^O')
        KChar 'v' -> changeInput (Edit.insert '\^V')
        KChar 'p' -> eventLoop (retreatFocus st)
        KChar 'n' -> eventLoop (advanceFocus st)
        KChar 'l' -> refreshClient st
        _         -> eventLoop st

    [MMeta] ->
      case key of
        KChar 'b' -> changeInput Edit.leftWord
        KChar 'f' -> changeInput Edit.rightWord
        KChar 'a' -> eventLoop (jumpToActivity st)
        KChar c   | Just i <- elemIndex c windowNames ->
                            eventLoop (jumpFocus i st)
        _ -> eventLoop st

    [] -> -- no modifier
      case key of
        KBS        -> changeInput Edit.backspace
        KDel       -> changeInput Edit.delete
        KLeft      -> changeInput Edit.left
        KRight     -> changeInput Edit.right
        KHome      -> changeInput Edit.home
        KEnd       -> changeInput Edit.end
        KUp        -> changeInput $ \ed -> maybe ed id $ Edit.earlier ed
        KDown      -> changeInput $ \ed -> maybe ed id $ Edit.later ed
        KEnter     -> execute st
        KPageUp    -> eventLoop (pageUp st)
        KPageDown  -> eventLoop (pageDown st)
        KBackTab   -> tabCompletion True  st
        KChar '\t' -> tabCompletion False st
        KChar c    -> changeInput (Edit.insert c)
        KFun 2     -> eventLoop (over clientDetailView not st)
        _          -> eventLoop st

    _ -> eventLoop st -- unsupported modifier

refreshClient :: ClientState -> IO ()
refreshClient st =
  do refresh (view clientVty st)
     eventLoop st

pageUp :: ClientState -> ClientState
pageUp st = over clientScroll (+ scrollAmount st) st

pageDown :: ClientState -> ClientState
pageDown st = over clientScroll (max 0 . subtract (scrollAmount st)) st

scrollAmount :: ClientState -> Int
scrollAmount st = max 1 (view clientHeight st - 2)

jumpToActivity :: ClientState -> ClientState
jumpToActivity st =
  case mplus highPriority lowPriority of
    Just (focus,_) -> changeFocus focus st
    Nothing        -> st
  where
    windowList = views clientWindows Map.toList st
    highPriority = find (view winMention . snd) windowList
    lowPriority  = find (\x -> view winUnread (snd x) > 0) windowList

jumpFocus :: Int -> ClientState -> ClientState
jumpFocus i st
  | 0 <= i, i < Map.size windows = changeFocus focus st
  | otherwise                    = st
  where
    windows = view clientWindows st
    (focus,_) = Map.elemAt i windows

tabCompletion :: Bool {- ^ reversed -} -> ClientState -> IO ()
tabCompletion isReversed st =
  case clientInput st of
    '/':command -> do res <- executeCommand (Just isReversed) command st
                      case res of
                        CommandQuit -> return ()
                        CommandContinue st' -> eventLoop st'
    _          -> eventLoop (nickTabCompletion isReversed st)

execute :: ClientState -> IO ()
execute st =
  case clientInput st of
    []          -> eventLoop st
    '/':command -> do res <- executeCommand Nothing command st
                      case res of
                        CommandQuit -> return ()
                        CommandContinue st' -> eventLoop st'
    msg         -> executeChat msg st

executeChat :: String -> ClientState -> IO ()
executeChat msg st =
  case view clientFocus st of
    ChannelFocus network channel
      | Just cs <- preview (clientConnection network) st ->
          do now <- getZonedTime
             let msgTxt = Text.pack msg
                 ircMsg = rawIrcMsg "PRIVMSG" [idText channel, msgTxt]
                 myNick = UserInfo (view csNick cs) Nothing Nothing
                 entry = ClientMessage
                            { _msgTime = now
                            , _msgNetwork = network
                            , _msgBody = IrcBody (Privmsg myNick channel msgTxt)
                            }
             sendMsg cs ircMsg
             eventLoop $ recordChannelMessage network channel entry
                       $ consumeInput st

    _ -> eventLoop st

doTimerEvent :: Int -> TimedAction -> ClientState -> IO ()
doTimerEvent networkId action st =
  do st' <- forOf (clientConnections . ix networkId) st $ \cs ->
                  case action of
                    TimedDisconnect ->
                      do abortConnection (view csSocket cs)
                         return $! set csNextPingTime Nothing cs

                    TimedSendPing ->
                      do now <- getCurrentTime
                         let cs' = set csNextPingTime (Just $! addUTCTime 60 now)
                                 $ set csPingStatus   (PingSent now) cs
                         sendMsg cs (rawIrcMsg "PING" ["ping"])
                         return $! cs'
     eventLoop st'
