module Business.Bookkeeping.Yearly.Monthly.TrialBalance
  ( YearlyMonthlyTrialBalance
  , mkYearlyMonthlyTrialBalance
  ) where

import Prelude
import Business.Bookkeeping.Class.Account (class Account)
import Business.Bookkeeping.Data.Yearly (Yearly)
import Business.Bookkeeping.Monthly.TrialBalance (MonthlyTrialBalance, mkMonthlyTrialBalance)
import Business.Bookkeeping.Yearly.GeneralLedger (YearlyGeneralLedger)
import Data.List (List)

type YearlyMonthlyTrialBalance a
  = Yearly (MonthlyTrialBalance a)

mkYearlyMonthlyTrialBalance :: forall c a. Account c a => List (YearlyGeneralLedger a) -> List (YearlyMonthlyTrialBalance a)
mkYearlyMonthlyTrialBalance =
  map \ygl ->
    { year: ygl.year
    , contents: mkMonthlyTrialBalance ygl.contents
    }
