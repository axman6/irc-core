{-# Language ForeignFunctionInterface, RecordWildCards #-}

{-|
Module      : Client.CApi.Types
Description : Marshaling support for C API
Copyright   : (c) Eric Mertens, 2016
License     : ISC
Maintainer  : emertens@gmail.com

Marshaling types and functions for the C API

-}

#include "glirc-api.h"

module Client.CApi.Types
  ( -- * Extension record
    FgnExtension(..)
  , StartExtension
  , StopExtension
  , ProcessMessage
  , ProcessCommand

  -- * Strings
  , FgnStringLen(..)

  -- * Messages
  , FgnMsg(..)

  -- * Commands
  , FgnCmd(..)

  -- * Function pointer calling
  , Dynamic
  , runStartExtension
  , runStopExtension
  , runProcessMessage
  , runProcessCommand

  -- * report message codes
  , MessageCode(..), normalMessage, errorMessage

  -- * process message results
  , MessageResult(..), passMessage, dropMessage
  ) where

import Foreign.C
import Foreign.Ptr
import Foreign.Storable

-- | Tag for describing the kind of message to display in the client
-- as used in `glirc_print`.
--
-- @enum message_code;@
newtype MessageCode = MessageCode CInt deriving Eq
#enum MessageCode, MessageCode, NORMAL_MESSAGE, ERROR_MESSAGE

-- | Result used to determine what to do after processing a message with
-- the 'ProcessMessage' callback.
--
-- @enum process_result;@
newtype MessageResult = MessageResult CInt deriving Eq
#enum MessageResult, MessageResult, PASS_MESSAGE, DROP_MESSAGE

--

-- | @typedef void *start(void *glirc, const char *path);@
type StartExtension =
  Ptr ()      {- ^ api token                   -} ->
  CString     {- ^ path to extension           -} ->
  IO (Ptr ()) {- ^ initialized extension state -}

-- | @typedef void stop(void *glirc, void *S);@
type StopExtension =
  Ptr () {- ^ api token       -} ->
  Ptr () {- ^ extension state -} ->
  IO ()

-- | @typedef enum process_result process_message(void *glirc, void *S, const struct glirc_message *);@
type ProcessMessage =
  Ptr ()     {- ^ api token       -} ->
  Ptr ()     {- ^ extention state -} ->
  Ptr FgnMsg {- ^ message to send -} ->
  IO MessageResult

-- | @typedef void process_command(void *glirc, void *S, const struct glirc_command *);@
type ProcessCommand =
  Ptr ()     {- ^ api token       -} ->
  Ptr ()     {- ^ extension state -} ->
  Ptr FgnCmd {- ^ command         -} ->
  IO ()

-- | Type of dynamic function pointer wrappers.
type Dynamic a = FunPtr a -> a

foreign import ccall "dynamic" runStartExtension :: Dynamic StartExtension
foreign import ccall "dynamic" runStopExtension  :: Dynamic StopExtension
foreign import ccall "dynamic" runProcessMessage :: Dynamic ProcessMessage
foreign import ccall "dynamic" runProcessCommand :: Dynamic ProcessCommand

------------------------------------------------------------------------

-- | @struct glirc_extension;@
data FgnExtension = FgnExtension
  { fgnStart   :: FunPtr StartExtension -- ^ Optional startup callback
  , fgnStop    :: FunPtr StopExtension  -- ^ Optional shutdown callback
  , fgnMessage :: FunPtr ProcessMessage -- ^ Optional message received callback
  , fgnCommand :: FunPtr ProcessCommand -- ^ Optional client command callback
  , fgnName    :: CString               -- ^ Null-terminated name
  , fgnMajorVersion, fgnMinorVersion :: CInt -- ^ extension version
  }

instance Storable FgnExtension where
  alignment _ = #alignment struct glirc_extension
  sizeOf    _ = #size      struct glirc_extension
  peek p      = FgnExtension
            <$> (#peek struct glirc_extension, start          ) p
            <*> (#peek struct glirc_extension, stop           ) p
            <*> (#peek struct glirc_extension, process_message) p
            <*> (#peek struct glirc_extension, process_command) p
            <*> (#peek struct glirc_extension, name           ) p
            <*> (#peek struct glirc_extension, major_version  ) p
            <*> (#peek struct glirc_extension, minor_version  ) p
  poke p FgnExtension{..} =
             do (#poke struct glirc_extension, start          ) p fgnStart
                (#poke struct glirc_extension, stop           ) p fgnStop
                (#poke struct glirc_extension, process_message) p fgnMessage
                (#poke struct glirc_extension, process_command) p fgnCommand
                (#poke struct glirc_extension, name           ) p fgnName
                (#poke struct glirc_extension, major_version  ) p fgnMajorVersion
                (#poke struct glirc_extension, minor_version  ) p fgnMinorVersion

------------------------------------------------------------------------

-- | @struct glirc_message@
data FgnMsg = FgnMsg
  { fmNetwork    :: FgnStringLen
  , fmPrefixNick :: FgnStringLen
  , fmPrefixUser :: FgnStringLen
  , fmPrefixHost :: FgnStringLen
  , fmCommand    :: FgnStringLen
  , fmParams     :: Ptr FgnStringLen -- ^ array
  , fmParamN     :: CSize            -- ^ array length
  , fmTagKeys    :: Ptr FgnStringLen -- ^ array
  , fmTagVals    :: Ptr FgnStringLen -- ^ array
  , fmTagN       :: CSize            -- ^ array length
  }

instance Storable FgnMsg where
  alignment _ = #alignment struct glirc_message
  sizeOf    _ = #size      struct glirc_message
  peek p      = FgnMsg
            <$> (#peek struct glirc_message, network ) p
            <*> (#peek struct glirc_message, prefix_nick) p
            <*> (#peek struct glirc_message, prefix_user) p
            <*> (#peek struct glirc_message, prefix_host) p
            <*> (#peek struct glirc_message, command ) p
            <*> (#peek struct glirc_message, params  ) p
            <*> (#peek struct glirc_message, params_n) p
            <*> (#peek struct glirc_message, tagkeys ) p
            <*> (#peek struct glirc_message, tagvals ) p
            <*> (#peek struct glirc_message, tags_n  ) p

  poke p FgnMsg{..} =
             do (#poke struct glirc_message, network ) p fmNetwork
                (#poke struct glirc_message, prefix_nick) p fmPrefixNick
                (#poke struct glirc_message, prefix_user) p fmPrefixUser
                (#poke struct glirc_message, prefix_host) p fmPrefixHost
                (#poke struct glirc_message, command ) p fmCommand
                (#poke struct glirc_message, params  ) p fmParams
                (#poke struct glirc_message, params_n) p fmParamN
                (#poke struct glirc_message, tagkeys ) p fmTagKeys
                (#poke struct glirc_message, tagvals ) p fmTagVals
                (#poke struct glirc_message, tags_n  ) p fmTagN

------------------------------------------------------------------------

-- | @struct glirc_command@
data FgnCmd = FgnCmd
  { fcParams  :: Ptr FgnStringLen -- ^ array
  , fcParamN  :: CSize            -- ^ array length
  }

instance Storable FgnCmd where
  alignment _ = #alignment struct glirc_command
  sizeOf    _ = #size      struct glirc_command
  peek p      = FgnCmd
            <$> (#peek struct glirc_command, params  ) p
            <*> (#peek struct glirc_command, params_n) p

  poke p FgnCmd{..} =
             do (#poke struct glirc_command, params  ) p fcParams
                (#poke struct glirc_command, params_n) p fcParamN

------------------------------------------------------------------------

-- | @struct glirc_string@
data FgnStringLen = FgnStringLen !CString !CSize

instance Storable FgnStringLen where
  alignment _ = #alignment struct glirc_string
  sizeOf    _ = #size      struct glirc_string
  peek p      = FgnStringLen
            <$> (#peek struct glirc_string, str) p
            <*> (#peek struct glirc_string, len) p
  poke p (FgnStringLen x y) =
             do (#poke struct glirc_string, str) p x
                (#poke struct glirc_string, len) p y
