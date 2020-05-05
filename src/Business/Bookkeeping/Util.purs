module Business.Bookkeeping.Util where

import Prelude
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Bounded (class GenericBottom, genericBottom)
import Data.Generic.Rep.Enum (class GenericEnum, genericSucc)
import Data.List as L
import Data.Tuple (Tuple(..))
import Data.Unfoldable1 (unfoldr1)

candidates ::
  forall a b.
  Generic a b =>
  GenericBottom b =>
  GenericEnum b =>
  L.List a
candidates = unfoldr1 (Tuple <*> genericSucc) genericBottom
