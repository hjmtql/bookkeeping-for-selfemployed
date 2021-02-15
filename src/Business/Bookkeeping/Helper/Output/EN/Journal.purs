module Business.Bookkeeping.Helper.Output.EN.Journal where

import Business.Bookkeeping.Class.Account (class Account)
import Business.Bookkeeping.Helper.Output.Date (Date, fromDate)
import Business.Bookkeeping.Journal (Journal)
import Record.CSV.Printer.SList (type (!), type (:), SLProxy(..))

type ENJournal a
  = { "No" :: Int
    , "Date" :: Date
    , "Summary" :: String
    , "Debit Account" :: a
    , "Credit Account" :: a
    , "Amount" :: Int
    }

fromJournal :: forall c a. Account c a => Journal a -> ENJournal a
fromJournal j =
  { "No": j.no
  , "Date": fromDate j.date
  , "Summary": j.summary
  , "Debit Account": j.debitAccount
  , "Credit Account": j.creditAccount
  , "Amount": j.amount
  }

type ENJournalHeaderOrder
  = "No"
      : "Date"
      : "Summary"
      : "Debit Account"
      : "Credit Account"
      ! "Amount"

journalOrder :: SLProxy ENJournalHeaderOrder
journalOrder = SLProxy
