module Business.Bookkeeping.Helper.Output.TrialBalanceSummary where

import Data.List
import Business.Bookkeeping.TrialBalanceSummary (TrialBalanceSummary)
import Data.Either (Either)
import Record.CSV.Error (CSVError)

class TrialBalanceSummaryOutput c where
  printTrialBalanceSummary :: List (TrialBalanceSummary c) -> Either CSVError String
