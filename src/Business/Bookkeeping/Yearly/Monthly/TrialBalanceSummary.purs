module Business.Bookkeeping.Yearly.Monthly.TrialBalanceSummary
  ( YearlyMonthlyTrialBalanceSummary
  , mkYearlyMonthlyTrialBalanceSummary
  ) where

import Prelude
import Business.Bookkeeping.Class.Account (class Account)
import Business.Bookkeeping.Class.Category (class AccountCategory)
import Business.Bookkeeping.Data.Yearly (Yearly)
import Business.Bookkeeping.Monthly.TrialBalanceSummary (MonthlyTrialBalanceSummary, mkMonthlyTrialBalanceSummary)
import Business.Bookkeeping.Yearly.GeneralLedger (YearlyGeneralLedger)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Bounded (class GenericBottom, class GenericTop)
import Data.Generic.Rep.Enum (class GenericBoundedEnum)
import Data.List (List)

type YearlyMonthlyTrialBalanceSummary c
  = Yearly (MonthlyTrialBalanceSummary c)

mkYearlyMonthlyTrialBalanceSummary ::
  forall c a rep.
  AccountCategory c =>
  Account c a =>
  Generic c rep =>
  GenericTop rep =>
  GenericBottom rep =>
  GenericBoundedEnum rep =>
  List (YearlyGeneralLedger a) -> List (YearlyMonthlyTrialBalanceSummary c)
mkYearlyMonthlyTrialBalanceSummary =
  map \ygl ->
    { year: ygl.year
    , contents: mkMonthlyTrialBalanceSummary ygl.contents
    }
