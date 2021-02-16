module Business.Bookkeeping.Class.Category where

import Prelude
import Data.Generic.EnumHelper (values)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Bounded (class GenericBottom, class GenericTop)
import Data.Generic.Rep.Enum (class GenericBoundedEnum)
import Data.List as L

-- 勘定科目の分類
class Eq c <= AccountCategory c

categories ::
  forall c rep.
  Generic c rep =>
  GenericTop rep =>
  GenericBottom rep =>
  GenericBoundedEnum rep =>
  AccountCategory c =>
  L.List c
categories = L.fromFoldable values
