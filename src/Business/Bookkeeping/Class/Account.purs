module Business.Bookkeeping.Class.Account
  ( class Account
  , cat
  , accounts
  ) where

import Prelude
import Business.Bookkeeping.Data.Category (Category)
import Business.Bookkeeping.Util (candidates)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Bounded (class GenericBottom)
import Data.Generic.Rep.Enum (class GenericEnum)
import Data.List as L
import Record.CSV.Printer.ToCSV (class ToCSV)

-- 勘定科目
class
  ( Eq a
  , Show a
  , ToCSV a
  ) <= Account a where
  cat :: a -> Category

accounts ::
  forall a b.
  Generic a b =>
  GenericBottom b =>
  GenericEnum b =>
  Account a =>
  L.List a
accounts = candidates
