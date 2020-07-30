module Business.Bookkeeping.Helper.Output.JP.Ledger where

import Business.Bookkeeping.Class.Account (class Account)
import Business.Bookkeeping.GeneralLedger (Ledger)
import Business.Bookkeeping.Helper.Output.Date (Date, fromDate)
import Data.Maybe (Maybe)
import Record.CSV.Printer.SList (type (!), type (:), SLProxy(..))

-- CSV出力時の総勘定元帳列
type JPLedger a
  = { "No" :: Int
    , "日付" :: Date
    , "摘要" :: String
    , "勘定科目" :: a
    , "借方金額" :: Maybe Int
    , "貸方金額" :: Maybe Int
    }

fromLedger :: forall a. Account a => Ledger a -> JPLedger a
fromLedger l =
  { "No": l.no
  , "日付": fromDate l.date
  , "摘要": l.summary
  , "勘定科目": l.account
  , "借方金額": l.debitAmount
  , "貸方金額": l.creditAmount
  }

-- CSV出力時の総勘定元帳列の順番
type JPLedgerHeaderOrder
  = "No"
      : "日付"
      : "摘要"
      : "勘定科目"
      : "借方金額"
      ! "貸方金額"

ledgerOrder :: SLProxy JPLedgerHeaderOrder
ledgerOrder = SLProxy
