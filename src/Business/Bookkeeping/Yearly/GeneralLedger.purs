module Business.Bookkeeping.Yearly.GeneralLedger
  ( YearlyGeneralLedger
  , mkYearlyGeneralLedgers
  ) where

import Prelude
import Business.Bookkeeping.Class.Account (class Account, accounts)
import Business.Bookkeeping.Data.Yearly (Yearly)
import Business.Bookkeeping.GeneralLedger (GeneralLedger, mkGeneralLedger)
import Business.Bookkeeping.Yearly.Journal (YearlyJournal)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Bounded (class GenericBottom)
import Data.Generic.Rep.Enum (class GenericEnum)
import Data.List (List)

type YearlyGeneralLedger a
  = Yearly (GeneralLedger a)

mkYearlyGeneralLedgers ::
  forall c a rep.
  Account c a =>
  Generic a rep =>
  GenericBottom rep =>
  GenericEnum rep =>
  List (YearlyJournal a) -> List (YearlyGeneralLedger a)
mkYearlyGeneralLedgers =
  map \yj ->
    { year: yj.year
    , contents:
        accounts
          <#> flip mkGeneralLedger yj.contents
    }