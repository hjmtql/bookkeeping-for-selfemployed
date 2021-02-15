module Business.Bookkeeping.Class.Account
  ( class Account
  , cat
  , accounts
  ) where

import Prelude
import Business.Bookkeeping.Class.Category (class AccountCategory)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Bounded (class GenericBottom)
import Data.Generic.Rep.Enum (class GenericEnum)
import Data.List as L
import Data.Sum.Helper (candidates)

-- 勘定科目
class
  ( AccountCategory c
  , Eq a
  ) <= Account c a | a -> c where
  cat :: a -> c

accounts ::
  forall c a rep.
  Generic a rep =>
  GenericBottom rep =>
  GenericEnum rep =>
  Account c a =>
  L.List a
accounts = L.fromFoldable candidates
