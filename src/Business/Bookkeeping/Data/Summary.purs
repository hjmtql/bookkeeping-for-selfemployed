module Business.Bookkeeping.Data.Summary where

import Prelude
import Business.Bookkeeping.GeneralLedger (Ledger)
import Business.Bookkeeping.Type (Money)
import Data.Foldable (sum)
import Data.List (List)
import Data.Maybe (fromMaybe)

type SummaryR r
  = { debitAmount :: Money
    , creditAmount :: Money
    , diffAmount :: Money
    | r
    }

mkSummary :: forall a. List (Ledger a) -> SummaryR ()
mkSummary ledgers =
  { debitAmount: debitTotal
  , creditAmount: creditTotal
  , diffAmount: creditTotal - debitTotal
  }
  where
  debitTotal = totalF _.debitAmount

  creditTotal = totalF _.creditAmount

  totalF prop = sum $ map (fromMaybe 0 <<< prop) ledgers
