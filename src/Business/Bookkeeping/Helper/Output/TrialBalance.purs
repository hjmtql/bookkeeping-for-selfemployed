module Business.Bookkeeping.Helper.Output.TrialBalance where

import Data.List
import Business.Bookkeeping.TrialBalance (TrialBalance)

class TrialBalanceOutput a where
  printTrialBalance :: List (TrialBalance a) -> String
