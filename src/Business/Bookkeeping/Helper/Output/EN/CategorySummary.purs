module Business.Bookkeeping.Helper.Output.En.CategorySummary where

import Business.Bookkeeping.CategorySummary (CategorySummary)
import Business.Bookkeeping.Class.Category (class AccountCategory)
import Record.CSV.Printer.SList (type (!), type (:), SLProxy(..))

type EnCategorySummary c
  = { "Category" :: c
    , "Debit Amount" :: Int
    , "Credit Amount" :: Int
    , "Diff Amount" :: Int
    }

fromCategorySummary :: forall c. AccountCategory c => CategorySummary c -> EnCategorySummary c
fromCategorySummary s =
  { "Category": s.category
  , "Debit Amount": s.debitAmount
  , "Credit Amount": s.creditAmount
  , "Diff Amount": s.diffAmount
  }

type EnCategorySummaryHeaderOrder
  = "Category"
      : "Debit Amount"
      : "Credit Amount"
      ! "Diff Amount"

categorySummaryOrder :: SLProxy EnCategorySummaryHeaderOrder
categorySummaryOrder = SLProxy
