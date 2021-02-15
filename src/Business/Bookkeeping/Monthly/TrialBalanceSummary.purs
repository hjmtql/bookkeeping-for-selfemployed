module Business.Bookkeeping.Monthly.TrialBalanceSummary
  ( MonthlyTrialBalanceSummary
  , mkMonthlyTrialBalanceSummary
  ) where

import Prelude
import Business.Bookkeeping.Class.Account (class Account)
import Business.Bookkeeping.Class.Category (class AccountCategory)
import Business.Bookkeeping.Data.Monthly (Monthly)
import Business.Bookkeeping.Monthly.TrialBalance (MonthlyTrialBalance)
import Business.Bookkeeping.TrialBalanceSummary (TrialBalanceSummary, mkTrialBalanceSummary)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Bounded (class GenericBottom)
import Data.Generic.Rep.Enum (class GenericEnum)
import Data.List (List)

-- 勘定科目分類別の月次合計残高試算表（BSとPL）
type MonthlyTrialBalanceSummary c
  = Monthly (TrialBalanceSummary c)

mkMonthlyTrialBalanceSummary ::
  forall c a rep.
  AccountCategory c =>
  Account c a =>
  Generic c rep =>
  GenericBottom rep =>
  GenericEnum rep =>
  List (MonthlyTrialBalance a) -> List (MonthlyTrialBalanceSummary c)
mkMonthlyTrialBalanceSummary =
  map \mtb ->
    { month: mtb.month
    , balances: mkTrialBalanceSummary mtb.balances
    }
