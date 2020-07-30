module Business.Bookkeeping.Helper.Output.JP.Journal where

import Business.Bookkeeping.Class.Account (class Account)
import Business.Bookkeeping.Helper.Output.Date (Date, fromDate)
import Business.Bookkeeping.Journal (Journal)
import Record.CSV.Printer.SList (type (!), type (:), SLProxy(..))

-- CSV出力時の仕訳帳列
type JPJournal a
  = { "No" :: Int
    , "日付" :: Date
    , "摘要" :: String
    , "借方勘定科目" :: a
    , "貸方勘定科目" :: a
    , "金額" :: Int
    }

fromJournal :: forall a. Account a => Journal a -> JPJournal a
fromJournal j =
  { "No": j.no
  , "日付": fromDate j.date
  , "摘要": j.summary
  , "借方勘定科目": j.debitAccount
  , "貸方勘定科目": j.creditAccount
  , "金額": j.amount
  }

-- CSV出力時の仕訳帳列の順番
type JPJournalHeaderOrder
  = "No"
      : "日付"
      : "摘要"
      : "借方勘定科目"
      : "貸方勘定科目"
      ! "金額"

journalOrder :: SLProxy JPJournalHeaderOrder
journalOrder = SLProxy
