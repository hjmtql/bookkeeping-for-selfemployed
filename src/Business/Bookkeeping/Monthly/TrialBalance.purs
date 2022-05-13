module Business.Bookkeeping.Monthly.TrialBalance
  ( MonthlyTrialBalance
  , mkMonthlyTrialBalance
  ) where

import Prelude
import Business.Bookkeeping.Class.Account (class Account)
import Business.Bookkeeping.Data.Monthly (Monthly, months)
import Business.Bookkeeping.Data.Summary (mkTrialBalanceR)
import Business.Bookkeeping.GeneralLedger (GeneralLedger)
import Business.Bookkeeping.TrialBalance (TrialBalance)
import Data.Date (month)
import Data.Functor (mapFlipped)
import Data.List (List, filter)
import Record (insert)
import Type.Proxy (Proxy(..))

-- 月次合計残高試算表
type MonthlyTrialBalance a
  = Monthly (TrialBalance a)

mkMonthlyTrialBalance :: forall c a. Account c a => List (GeneralLedger a) -> List (MonthlyTrialBalance a)
mkMonthlyTrialBalance gls =
  months
    <#> \m ->
        { month: m
        , balances:
            mapFlipped gls \gl ->
              gl.ledgers
                # filter (\l -> month l.date == m)
                # mkTrialBalanceR
                # insert (Proxy :: Proxy "account") gl.account
        }
