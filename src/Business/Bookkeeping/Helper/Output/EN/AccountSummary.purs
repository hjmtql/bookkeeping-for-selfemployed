module Business.Bookkeeping.Helper.Output.En.AccountSummary where

import Business.Bookkeeping.AccountSummary (AccountSummary)
import Business.Bookkeeping.Class.Account (class Account)
import Record.CSV.Printer.SList (type (!), type (:), SLProxy(..))

type EnAccountSummary a
  = { "Account" :: a
    , "Debit Amount" :: Int
    , "Credit Amount" :: Int
    , "Diff Amount" :: Int
    }

fromAccountSummary :: forall a. Account a => AccountSummary a -> EnAccountSummary a
fromAccountSummary s =
  { "Account": s.account
  , "Debit Amount": s.debitAmount
  , "Credit Amount": s.creditAmount
  , "Diff Amount": s.diffAmount
  }

type EnAccountSummaryHeaderOrder
  = "Account"
      : "Debit Amount"
      : "Credit Amount"
      ! "Diff Amount"

accountSummaryOrder :: SLProxy EnAccountSummaryHeaderOrder
accountSummaryOrder = SLProxy
