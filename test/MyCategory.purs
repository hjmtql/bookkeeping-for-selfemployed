module Test.MyCategory where

import Prelude
import Business.Bookkeeping.Class.Category (class AccountCategory)
import Business.Bookkeeping.Helper.Output.CategorySummary (class CategorySummaryOutput)
import Business.Bookkeeping.Helper.Output.JP.CategorySummary as JP
import Business.Bookkeeping.Helper.PathName (class PathName)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Record.CSV.Printer (printCSVWithOrder)
import Record.CSV.Printer.ToCSV (class ToCSV)

-- 勘定科目の分類
data MyCategory
  = Assets
  | Liabilities
  | Stock
  | Revenue
  | Expenses

derive instance eqMyCategory :: Eq MyCategory

derive instance geneticMyCategory :: Generic MyCategory _

instance accountCategoryMyCategory :: AccountCategory MyCategory

-- CSV出力時の名称
instance toCSVMyCategory :: ToCSV MyCategory where
  toCSV Assets = "資産"
  toCSV Liabilities = "負債"
  toCSV Stock = "資本"
  toCSV Revenue = "収益"
  toCSV Expenses = "費用"

-- 総勘定元帳CSV出力時のフォルダ名
instance pathNameMyCategory :: PathName MyCategory where
  pathName = genericShow

-- 勘定科目の分類別の合計金額CSV出力時の設定
instance categorySummaryOutputMyCategory :: CategorySummaryOutput MyCategory where
  printCategorySummary = printCSVWithOrder JP.categorySummaryOrder <<< map JP.fromCategorySummary
