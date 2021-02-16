module Business.Bookkeeping.Helper.Output.Ledger where

import Business.Bookkeeping.GeneralLedger (Ledger)
import Data.List

class LedgerOutput a where
  printLedger :: List (Ledger a) -> String
