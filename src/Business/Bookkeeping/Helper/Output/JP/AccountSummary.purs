module Business.Bookkeeping.Helper.Output.JP.AccountSummary where

import Business.Bookkeeping.AccountSummary (AccountSummary)
import Business.Bookkeeping.Class.Account (class Account)
import Record.CSV.Printer.SList (type (!), type (:), SLProxy(..))

type JPAccountSummary a
  = { "勘定科目" :: a
    , "借方金額" :: Int
    , "貸方金額" :: Int
    , "差異金額" :: Int
    }

fromAccountSummary :: forall c a. Account c a => AccountSummary a -> JPAccountSummary a
fromAccountSummary s =
  { "勘定科目": s.account
  , "借方金額": s.debitAmount
  , "貸方金額": s.creditAmount
  , "差異金額": s.diffAmount
  }

type JPAccountSummaryHeaderOrder
  = "勘定科目"
      : "借方金額"
      : "貸方金額"
      ! "差異金額"

accountSummaryOrder :: SLProxy JPAccountSummaryHeaderOrder
accountSummaryOrder = SLProxy
