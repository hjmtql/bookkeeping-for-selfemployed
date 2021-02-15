module Business.Bookkeeping.GeneralLedger
  ( GeneralLedger
  , Ledger
  , mkGeneralLedger
  ) where

import Prelude
import Business.Bookkeeping.Class.Account (class Account)
import Business.Bookkeeping.Journal (Journal)
import Business.Bookkeeping.Type (Money)
import Data.Date (Date)
import Data.List as L
import Data.Maybe (Maybe(..))

-- 総勘定元帳
type GeneralLedger a
  = { account :: a
    , ledgers :: L.List (Ledger a)
    }

type Ledger a
  = { no :: Int
    , date :: Date
    , summary :: String
    , account :: a
    , debitAmount :: Maybe Money
    , creditAmount :: Maybe Money
    }

mkGeneralLedger :: forall a c. Account c a => a -> L.List (Journal a) -> GeneralLedger a
mkGeneralLedger a js = { account: a, ledgers: ls }
  where
  ls = L.sortBy (comparing _.no) $ ds <> cs

  ds = mkD <$> L.filter (\t -> t.debitAccount == a) js

  cs = mkC <$> L.filter (\t -> t.creditAccount == a) js

mkD :: forall a. Journal a -> Ledger a
mkD t =
  { no: t.no
  , date: t.date
  , summary: t.summary
  , account: t.creditAccount
  , debitAmount: Just t.amount
  , creditAmount: Nothing
  }

mkC :: forall a. Journal a -> Ledger a
mkC t =
  { no: t.no
  , date: t.date
  , summary: t.summary
  , account: t.debitAccount
  , debitAmount: Nothing
  , creditAmount: Just t.amount
  }
