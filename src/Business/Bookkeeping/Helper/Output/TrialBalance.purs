module Business.Bookkeeping.Helper.Output.TrialBalance where

import Data.List
import Business.Bookkeeping.TrialBalance (TrialBalance)
import Data.Either (Either)
import Record.CSV.Error (CSVError)

class TrialBalanceOutput a where
  printTrialBalance :: List (TrialBalance a) -> Either CSVError String
