module Business.Bookkeeping.Class.Category where

import Prelude
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Bounded (class GenericBottom)
import Data.Generic.Rep.Enum (class GenericEnum)
import Data.List as L
import Data.Sum.Helper (candidates)

-- 勘定科目の分類
class Eq c <= AccountCategory c

categories ::
  forall c rep.
  Generic c rep =>
  GenericBottom rep =>
  GenericEnum rep =>
  AccountCategory c =>
  L.List c
categories = L.fromFoldable candidates
