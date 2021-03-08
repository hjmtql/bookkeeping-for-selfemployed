module Test.MyCategory where

import Prelude
import Business.Bookkeeping.Class.Category (class AccountCategory)
import Business.Bookkeeping.Helper.Output.JP.TrialBalanceSummary as JP
import Business.Bookkeeping.Helper.Output.TrialBalanceSummary (class TrialBalanceSummaryOutput)
import Business.Bookkeeping.Helper.PathName (class PathName)
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import Record.CSV.Printer (printCSVWithOrder)
import Record.CSV.Printer.ToCSV (class ToCSV)

-- 勘定科目分類
data MyCategory
  = Assets
  | Liabilities
  | Stock
  | Revenue
  | Expenses

derive instance eqMyCategory :: Eq MyCategory

derive instance geneticMyCategory :: Generic MyCategory _

instance showMyCategory :: Show MyCategory where
  show = genericShow

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

-- 勘定科目分類別の合計残高試算表CSV出力時の設定
instance trialBalanceSummaryOutputMyCategory :: TrialBalanceSummaryOutput MyCategory where
  printTrialBalanceSummary = printCSVWithOrder JP.trialBalanceSummaryOrder <<< map JP.fromTrialBalanceSummary
