module Business.Bookkeeping.AccountSummary
  ( AccountSummary
  , mkAccountSummary
  ) where

import Prelude
import Business.Bookkeeping.Class.Account (class Account)
import Business.Bookkeeping.Data.Summary (SummaryR, mkSummary)
import Business.Bookkeeping.GeneralLedger (GeneralLedger)
import Data.List (List)
import Data.Symbol (SProxy(..))
import Record (insert)

-- 勘定科目別の合計金額
type AccountSummary a
  = SummaryR ( account :: a )

mkAccountSummary :: forall a. Account a => List (GeneralLedger a) -> List (AccountSummary a)
mkAccountSummary =
  map
    ( \l ->
        insert (SProxy :: SProxy "account") l.account
          $ mkSummary l.ledgers
    )
