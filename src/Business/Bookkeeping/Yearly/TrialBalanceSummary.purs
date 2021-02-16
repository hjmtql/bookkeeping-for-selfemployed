module Business.Bookkeeping.Yearly.TrialBalanceSummary
  ( YearlyTrialBalanceSummary
  , mkYearlyTrialBalanceSummary
  ) where

import Prelude hiding (class Category)
import Business.Bookkeeping.Class.Account (class Account)
import Business.Bookkeeping.Class.Category (class AccountCategory)
import Business.Bookkeeping.Data.Yearly (Yearly)
import Business.Bookkeeping.TrialBalanceSummary (TrialBalanceSummary, mkTrialBalanceSummary)
import Business.Bookkeeping.Yearly.GeneralLedger (YearlyGeneralLedger)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Bounded (class GenericBottom)
import Data.Generic.Rep.Enum (class GenericEnum)
import Data.List (List)

type YearlyTrialBalanceSummary c
  = Yearly (TrialBalanceSummary c)

mkYearlyTrialBalanceSummary ::
  forall c a rep.
  AccountCategory c =>
  Account c a =>
  Generic c rep =>
  GenericBottom rep =>
  GenericEnum rep =>
  List (YearlyGeneralLedger a) -> List (YearlyTrialBalanceSummary c)
mkYearlyTrialBalanceSummary =
  map \ygl ->
    { year: ygl.year
    , contents: mkTrialBalanceSummary ygl.contents
    }
