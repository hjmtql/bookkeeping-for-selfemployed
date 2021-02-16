module Business.Bookkeeping.Class.Account
  ( class Account
  , cat
  , accounts
  ) where

import Prelude
import Business.Bookkeeping.Class.Category (class AccountCategory)
import Data.Generic.EnumHelper (values)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Bounded (class GenericBottom, class GenericTop)
import Data.Generic.Rep.Enum (class GenericBoundedEnum)
import Data.List as L

-- 勘定科目
class
  ( AccountCategory c
  , Eq a
  ) <= Account c a | a -> c where
  cat :: a -> c

accounts ::
  forall c a rep.
  Generic a rep =>
  GenericTop rep =>
  GenericBottom rep =>
  GenericBoundedEnum rep =>
  Account c a =>
  L.List a
accounts = L.fromFoldable values
