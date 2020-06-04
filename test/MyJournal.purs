module Test.MyJournal where

import Business.Bookkeeping.Journal (Journal)
import Record.CSV.Printer.SList (type (!), type (:), SLProxy(..))
import Test.MyAccount (MyAccount)
import Test.MyDate (MyDate, fromDate)

-- CSV出力時の仕訳帳列
type MyJournal
  = { "No" :: Int
    , "日付" :: MyDate
    , "摘要" :: String
    , "借方勘定科目" :: MyAccount
    , "貸方勘定科目" :: MyAccount
    , "金額" :: Int
    }

fromJournal :: Journal MyAccount -> MyJournal
fromJournal j =
  { "No": j.no
  , "日付": fromDate j.date
  , "摘要": j.summary
  , "借方勘定科目": j.debitAccount
  , "貸方勘定科目": j.creditAccount
  , "金額": j.amount
  }

-- CSV出力時の仕訳帳列の順番
type JournalHeaderOrder
  = "No"
      : "日付"
      : "摘要"
      : "借方勘定科目"
      : "貸方勘定科目"
      ! "金額"

journalOrder :: SLProxy JournalHeaderOrder
journalOrder = SLProxy
