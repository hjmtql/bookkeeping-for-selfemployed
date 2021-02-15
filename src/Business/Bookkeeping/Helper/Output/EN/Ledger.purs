module Business.Bookkeeping.Helper.Output.EN.Ledger where

import Business.Bookkeeping.Class.Account (class Account)
import Business.Bookkeeping.GeneralLedger (Ledger)
import Business.Bookkeeping.Helper.Output.Date (Date, fromDate)
import Data.Maybe (Maybe)
import Record.CSV.Printer.SList (type (!), type (:), SLProxy(..))

type ENLedger a
  = { "No" :: Int
    , "Date" :: Date
    , "Summary" :: String
    , "Account" :: a
    , "Debit Amount" :: Maybe Int
    , "Credit Amount" :: Maybe Int
    }

fromLedger :: forall c a. Account c a => Ledger a -> ENLedger a
fromLedger l =
  { "No": l.no
  , "Date": fromDate l.date
  , "Summary": l.summary
  , "Account": l.account
  , "Debit Amount": l.debitAmount
  , "Credit Amount": l.creditAmount
  }

type ENLedgerHeaderOrder
  = "No"
      : "Date"
      : "Summary"
      : "Account"
      : "Debit Amount"
      ! "Credit Amount"

ledgerOrder :: SLProxy ENLedgerHeaderOrder
ledgerOrder = SLProxy
