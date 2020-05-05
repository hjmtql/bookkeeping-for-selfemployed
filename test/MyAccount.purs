module Test.MyAccount where

import Prelude
import Business.Bookkeeping.Class.Account (class Account)
import Business.Bookkeeping.Data.Category (Category(..))
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Record.CSV.Printer.ToCSV (class ToCSV)

-- 勘定科目
data MyAccount
  = Cash
  | Bank
  | Sales
  | Rent
  | Communication
  | Utilities
  | Travel
  | Supplies
  | Commission

-- 勘定科目の分類
instance accountMyAccount :: Account MyAccount where
  cat Cash = Assets
  cat Bank = Assets
  cat Sales = Revenue
  cat Rent = Expenses
  cat Communication = Expenses
  cat Utilities = Expenses
  cat Travel = Expenses
  cat Supplies = Expenses
  cat Commission = Expenses

-- CSV出力時の名称
instance toCSVMyAccount :: ToCSV MyAccount where
  toCSV Cash = "現金"
  toCSV Bank = "預金"
  toCSV Sales = "売上"
  toCSV Rent = "地代家賃"
  toCSV Communication = "通信費"
  toCSV Utilities = "水道光熱費"
  toCSV Travel = "交通費"
  toCSV Supplies = "消耗品費"
  toCSV Commission = "支払手数料"

derive instance eqMyAccount :: Eq MyAccount

derive instance geneticMyAccount :: Generic MyAccount _

instance showMyAccount :: Show MyAccount where
  show = genericShow
