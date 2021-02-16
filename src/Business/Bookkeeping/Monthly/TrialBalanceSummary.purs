module Business.Bookkeeping.Monthly.TrialBalanceSummary
  ( MonthlyTrialBalanceSummary
  , mkMonthlyTrialBalanceSummary
  ) where

import Prelude
import Business.Bookkeeping.Class.Account (class Account, cat)
import Business.Bookkeeping.Class.Category (class AccountCategory, categories)
import Business.Bookkeeping.Data.Monthly (Monthly, months)
import Business.Bookkeeping.Data.Summary (mkTrialBalanceR)
import Business.Bookkeeping.GeneralLedger (GeneralLedger)
import Business.Bookkeeping.TrialBalanceSummary (TrialBalanceSummary)
import Data.Date (month)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Bounded (class GenericBottom, class GenericTop)
import Data.Generic.Rep.Enum (class GenericBoundedEnum)
import Data.List (List, concatMap, filter)
import Data.Symbol (SProxy(..))
import Record (insert)

-- 勘定科目分類別の月次合計残高試算表（BSとPL）
type MonthlyTrialBalanceSummary c
  = Monthly (TrialBalanceSummary c)

mkMonthlyTrialBalanceSummary ::
  forall c a rep.
  AccountCategory c =>
  Account c a =>
  Generic c rep =>
  GenericTop rep =>
  GenericBottom rep =>
  GenericBoundedEnum rep =>
  List (GeneralLedger a) -> List (MonthlyTrialBalanceSummary c)
mkMonthlyTrialBalanceSummary gls =
  months
    <#> \m ->
        { month: m
        , balances:
            categories
              <#> \c ->
                  filter (\gl -> cat gl.account == c) gls
                    # concatMap _.ledgers
                    # filter (\l -> month l.date == m)
                    # mkTrialBalanceR
                    # insert (SProxy :: SProxy "category") c
        }
