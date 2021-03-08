module Business.Bookkeeping.Class.Account
  ( class Account
  , cat
  , accounts
  ) where

import Prelude
import Business.Bookkeeping.Class.Category (class AccountCategory)
import Data.Bounded.Generic (class GenericBottom, class GenericTop)
import Data.Enum.Generic (class GenericBoundedEnum)
import Data.Generic.EnumHelper (values)
import Data.Generic.Rep (class Generic)
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
