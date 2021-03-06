{-|
Module      : Client.View.Messages
Description : Chat message view
Copyright   : (c) Eric Mertens, 2016
License     : ISC
Maintainer  : emertens@gmail.com

This module returns the chat messages for the currently focused
window in message view and gathers metadata entries into single
lines.

-}
module Client.View.Messages
  ( chatMessageImages
  ) where

import           Client.Image.Palette
import           Client.Image.Message
import           Client.State
import           Client.State.Focus
import           Client.State.Network
import           Client.State.Window
import           Client.Message
import           Control.Lens
import           Control.Monad
import           Irc.Identifier
import           Irc.Message
import           Graphics.Vty.Image

chatMessageImages :: Focus -> ClientState -> [Image]
chatMessageImages focus st = windowLineProcessor focusedMessages
  where
    matcher = clientMatcher st

    focusedMessages
        = toListOf ( clientWindows . ix focus
                   . winMessages . each
                   . filtered (views wlText matcher)) st

    windowLineProcessor

      | view clientDetailView st =
          if view clientShowMetadata st
            then map (view wlFullImage)
            else detailedImagesWithoutMetadata st

      | otherwise = windowLinesToImages st . filter (not . isNoisy)

    isNoisy msg =
      case view wlSummary msg of
        ReplySummary code -> squelchIrcMsg (Reply code [])
        _                 -> False

detailedImagesWithoutMetadata :: ClientState -> [WindowLine] -> [Image]
detailedImagesWithoutMetadata st wwls =
  case gatherMetadataLines st wwls of
    ([], [])   -> []
    ([], w:ws) -> view wlFullImage w : detailedImagesWithoutMetadata st ws
    (_:_, wls) -> detailedImagesWithoutMetadata st wls

windowLinesToImages :: ClientState -> [WindowLine] -> [Image]
windowLinesToImages st wwls =
  case gatherMetadataLines st wwls of
    ([], [])   -> []
    ([], w:ws) -> view wlImage w : windowLinesToImages st ws
    ((img,who,mbnext):mds, wls)

      | view clientShowMetadata st ->
         startMetadata img mbnext who mds palette
       : windowLinesToImages st wls

      | otherwise -> windowLinesToImages st wls
  where
    palette = clientPalette st

------------------------------------------------------------------------

type MetadataState =
  Identifier                            {- ^ current nick -} ->
  [(Image,Identifier,Maybe Identifier)] {- ^ metadata     -} ->
  Palette                               {- ^ palette      -} ->
  Image

startMetadata ::
  Image            {- ^ metadata image           -} ->
  Maybe Identifier {- ^ possible nick transition -} ->
  MetadataState
startMetadata img mbnext who mds palette =
        quietIdentifier palette who
    <|> img
    <|> transitionMetadata mbnext who mds palette

transitionMetadata ::
  Maybe Identifier {- ^ possible nick transition -} ->
  MetadataState
transitionMetadata mbwho who mds palette =
  case mbwho of
    Nothing   -> continueMetadata who  mds palette
    Just who' -> quietIdentifier palette who'
             <|> continueMetadata who' mds palette

continueMetadata :: MetadataState
continueMetadata _ [] _ = emptyImage
continueMetadata who1 ((img, who2, mbwho3):mds) palette
  | who1 == who2 = img
               <|> transitionMetadata mbwho3 who2 mds palette
  | otherwise    = char defAttr ' '
               <|> startMetadata img mbwho3 who2 mds palette

------------------------------------------------------------------------

gatherMetadataLines ::
  ClientState ->
  [WindowLine] ->
  ( [(Image, Identifier, Maybe Identifier)] , [ WindowLine ] )
  -- ^ metadata entries are reversed
gatherMetadataLines st = go []
  where
    go acc (w:ws)
      | Just (img,who,mbnext) <- metadataWindowLine st w =
          go ((img,who,mbnext) : acc) ws

    go acc ws = (acc,ws)


-- | Classify window lines for metadata coalesence
metadataWindowLine ::
  ClientState ->
  WindowLine ->
  Maybe (Image, Identifier, Maybe Identifier)
        {- ^ Image, incoming identifier, outgoing identifier if changed -}
metadataWindowLine st wl =
  case view wlSummary wl of
    ChatSummary who -> (ignoreImage, who, Nothing) <$ guard (identIgnored who st)
    summary         -> metadataImg summary
