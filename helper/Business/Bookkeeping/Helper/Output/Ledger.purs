module Business.Bookkeeping.Helper.Output.Ledger where

import Business.Bookkeeping.GeneralLedger (Ledger)
import Data.Either (Either)
import Data.List
import Record.CSV.Error (CSVError)

class LedgerOutput a where
  printLedger :: List (Ledger a) -> Either CSVError String
