module Business.Bookkeeping.Helper.Output.JP.CategorySummary where

import Business.Bookkeeping.CategorySummary (CategorySummary)
import Business.Bookkeeping.Class.Category (class AccountCategory)
import Record.CSV.Printer.SList (type (!), type (:), SLProxy(..))

type JPCategorySummary c
  = { "勘定科目分類" :: c
    , "借方金額" :: Int
    , "貸方金額" :: Int
    , "差異金額" :: Int
    }

fromCategorySummary :: forall c. AccountCategory c => CategorySummary c -> JPCategorySummary c
fromCategorySummary s =
  { "勘定科目分類": s.category
  , "借方金額": s.debitAmount
  , "貸方金額": s.creditAmount
  , "差異金額": s.diffAmount
  }

type JPCategorySummaryHeaderOrder
  = "勘定科目分類"
      : "借方金額"
      : "貸方金額"
      ! "差異金額"

categorySummaryOrder :: SLProxy JPCategorySummaryHeaderOrder
categorySummaryOrder = SLProxy
