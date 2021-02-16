module Business.Bookkeeping.Yearly.TrialBalance
  ( YearlyTrialBalance
  , mkYearlyTrialBalance
  ) where

import Prelude
import Business.Bookkeeping.Class.Account (class Account)
import Business.Bookkeeping.Data.Yearly (Yearly)
import Business.Bookkeeping.TrialBalance (TrialBalance, mkTrialBalance)
import Business.Bookkeeping.Yearly.GeneralLedger (YearlyGeneralLedger)
import Data.List (List)

type YearlyTrialBalance a
  = Yearly (TrialBalance a)

mkYearlyTrialBalance :: forall c a. Account c a => List (YearlyGeneralLedger a) -> List (YearlyTrialBalance a)
mkYearlyTrialBalance =
  map \ygl ->
    { year: ygl.year
    , contents: mkTrialBalance ygl.contents
    }
