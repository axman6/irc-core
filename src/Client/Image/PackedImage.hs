{-# Language TypeOperators, MultiParamTypeClasses, DeriveGeneric #-}
{-# OPTIONS_GHC -Wno-orphans -funfolding-creation-threshold=1500 -funfolding-use-threshold=5000 #-}
{-|
Module      : Client.Image.PackedImage
Description : Packed vty Image type
Copyright   : (c) Eric Mertens, 2016
License     : ISC
Maintainer  : emertens@gmail.com

This module provides a more memory efficient way to store images.

-}
module Client.Image.PackedImage
  ( Image'
  , _Image'
  ) where

import           Control.Lens (Iso', iso)
import qualified Data.Text as S
import qualified Data.Text.Lazy as L
import           Data.List
import           GHC.Generics
import           Graphics.Vty.Image
import           Graphics.Vty.Image.Internal


-- | Isomorphism between packed images and normal images.
_Image' :: Iso' Image' Image
_Image' = iso mirror (mirror . compress)
{-# INLINE _Image' #-}


-- | Attempts to locate adjacent text sections with equal attributes
-- so that they can be merged.
compress :: Image -> Image
compress = horizCat . map horizCat . groupBy textsWithEqAttr . flip horizList []


textsWithEqAttr :: Image -> Image -> Bool
textsWithEqAttr (HorizText a _ _ _) (HorizText b _ _ _) = a == b
textsWithEqAttr _                 _                     = False


horizList :: Image -> [Image] -> [Image]
horizList (HorizJoin x y _ _) = horizList x . horizList y
horizList x = (x:)


-- | Packed, strict version of 'Image' used for long-term storage of images.
data Image'
  = HorizText'
      Attr -- don't unpack, these get reused from the palette
      {-# UNPACK #-} !S.Text
      {-# UNPACK #-} !Int
      {-# UNPACK #-} !Int
  | HorizJoin'
      !Image'
      !Image'
      {-# UNPACK #-} !Int
      {-# UNPACK #-} !Int
  | VertJoin'
      !Image'
      !Image'
      {-# UNPACK #-} !Int
      {-# UNPACK #-} !Int
  | BGFill'
      {-# UNPACK #-} !Int
      {-# UNPACK #-} !Int
  | CropRight'
      !Image'
      {-# UNPACK #-} !Int
      {-# UNPACK #-} !Int
  | CropLeft'
      !Image'
      {-# UNPACK #-} !Int
      {-# UNPACK #-} !Int
      {-# UNPACK #-} !Int
  | CropBottom'
      !Image'
      {-# UNPACK #-} !Int
      {-# UNPACK #-} !Int
  | CropTop'
      !Image'
      {-# UNPACK #-} !Int
      {-# UNPACK #-} !Int
      {-# UNPACK #-} !Int
  | EmptyImage'
  deriving (Show, Generic)

------------------------------------------------------------------------

class    Mirror a      b      where mirror :: a -> b
instance Mirror Attr   Attr   where mirror = id
instance Mirror Int    Int    where mirror = id
instance Mirror L.Text S.Text where mirror = L.toStrict
instance Mirror S.Text L.Text where mirror = L.fromStrict
instance Mirror Image  Image' where mirror = to . gmirror . from
instance Mirror Image' Image  where mirror = to . gmirror . from

------------------------------------------------------------------------

class GMirror f g where
  gmirror :: f p -> g q

instance GMirror f g => GMirror (M1 i c f) (M1 j d g) where
  gmirror (M1 x) = M1 (gmirror x)

instance (GMirror f1 g1, GMirror f2 g2) => GMirror (f1 :*: f2) (g1 :*: g2) where
  gmirror (x :*: y) = gmirror x :*: gmirror y

instance (GMirror f1 g1, GMirror f2 g2) => GMirror (f1 :+: f2) (g1 :+: g2) where
  gmirror (L1 x) = L1 (gmirror x)
  gmirror (R1 x) = R1 (gmirror x)

instance GMirror U1 U1 where
  gmirror _ = U1

instance Mirror a b => GMirror (K1 i a) (K1 j b) where
  gmirror (K1 x) = K1 (mirror x)
