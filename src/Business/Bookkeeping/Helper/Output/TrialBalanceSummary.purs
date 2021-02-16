module Business.Bookkeeping.Helper.Output.TrialBalanceSummary where

import Data.List
import Business.Bookkeeping.TrialBalanceSummary (TrialBalanceSummary)

class TrialBalanceSummaryOutput c where
  printTrialBalanceSummary :: List (TrialBalanceSummary c) -> String
