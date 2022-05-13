module Business.Bookkeeping.TrialBalance
  ( TrialBalance
  , mkTrialBalance
  ) where

import Prelude
import Business.Bookkeeping.Class.Account (class Account)
import Business.Bookkeeping.Data.Summary (TrialBalanceR, mkTrialBalanceR)
import Business.Bookkeeping.GeneralLedger (GeneralLedger)
import Data.List (List)
import Record (insert)
import Type.Proxy (Proxy(..))

-- 合計残高試算表
type TrialBalance a
  = TrialBalanceR ( account :: a )

mkTrialBalance :: forall c a. Account c a => List (GeneralLedger a) -> List (TrialBalance a)
mkTrialBalance =
  map \gl ->
    mkTrialBalanceR gl.ledgers
      # insert (Proxy :: Proxy "account") gl.account
