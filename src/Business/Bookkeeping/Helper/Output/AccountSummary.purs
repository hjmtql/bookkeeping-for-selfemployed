module Business.Bookkeeping.Helper.Output.AccountSummary where

import Data.List
import Business.Bookkeeping.AccountSummary (AccountSummary)
import Data.Either (Either)
import Record.CSV.Error (CSVError)

class AccountSummaryOutput a where
  printAccountSummary :: List (AccountSummary a) -> Either CSVError String
