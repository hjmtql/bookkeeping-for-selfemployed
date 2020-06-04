module Test.MyLedger where

import Business.Bookkeeping.GeneralLedger (Ledger)
import Record.CSV.Printer.SList (type (!), type (:), SLProxy(..))
import Data.Maybe (Maybe)
import Test.MyAccount (MyAccount)
import Test.MyDate (MyDate, fromDate)

-- CSV出力時の総勘定元帳列
type MyLedger
  = { "No" :: Int
    , "日付" :: MyDate
    , "摘要" :: String
    , "勘定科目" :: MyAccount
    , "借方金額" :: Maybe Int
    , "貸方金額" :: Maybe Int
    }

fromLedger :: Ledger MyAccount -> MyLedger
fromLedger l =
  { "No": l.no
  , "日付": fromDate l.date
  , "摘要": l.summary
  , "勘定科目": l.account
  , "借方金額": l.debitAmount
  , "貸方金額": l.creditAmount
  }

-- CSV出力時の総勘定元帳列の順番
type LedgerHeaderOrder
  = "No"
      : "日付"
      : "摘要"
      : "勘定科目"
      : "借方金額"
      ! "貸方金額"

ledgerOrder :: SLProxy LedgerHeaderOrder
ledgerOrder = SLProxy
