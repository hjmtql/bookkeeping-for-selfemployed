module Test.MyAccount where

import Prelude
import Business.Bookkeeping.Class.Account (class Account)
import Business.Bookkeeping.Data.Category (Category(..))
import Business.Bookkeeping.Helper.Output.AccountSummary (class AccountSummaryOutput)
import Business.Bookkeeping.Helper.Output.JP.AccountSummary (fromAccountSummary, accountSummaryOrder) as JP
import Business.Bookkeeping.Helper.Output.JP.Journal (fromJournal, journalOrder) as JP
import Business.Bookkeeping.Helper.Output.JP.Ledger (fromLedger, ledgerOrder) as JP
import Business.Bookkeeping.Helper.Output.Journal (class JournalOutput)
import Business.Bookkeeping.Helper.Output.Ledger (class LedgerOutput)
import Business.Bookkeeping.Helper.PathName (class PathName)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Record.CSV.Printer (printCSVWithOrder)
import Record.CSV.Printer.ToCSV (class ToCSV)

-- 勘定科目
data MyAccount
  = WithdrawalsByOwner
  | InvestmentsByOwner
  | Sales
  | Rent
  | Communication
  | Utilities
  | Travel
  | Supplies
  | Commission

-- 勘定科目の分類
instance accountMyAccount :: Account MyAccount where
  cat WithdrawalsByOwner = Assets
  cat InvestmentsByOwner = Liabilities
  cat Sales = Revenue
  cat Rent = Expenses
  cat Communication = Expenses
  cat Utilities = Expenses
  cat Travel = Expenses
  cat Supplies = Expenses
  cat Commission = Expenses

-- CSV出力時の名称
instance toCSVMyAccount :: ToCSV MyAccount where
  toCSV WithdrawalsByOwner = "事業主貸"
  toCSV InvestmentsByOwner = "事業主借"
  toCSV Sales = "売上"
  toCSV Rent = "地代家賃"
  toCSV Communication = "通信費"
  toCSV Utilities = "水道光熱費"
  toCSV Travel = "交通費"
  toCSV Supplies = "消耗品費"
  toCSV Commission = "支払手数料"

derive instance eqMyAccount :: Eq MyAccount

derive instance geneticMyAccount :: Generic MyAccount _

-- 総勘定元帳CSV出力時のファイル名
instance pathNameMyAccount :: PathName MyAccount where
  pathName = genericShow

-- 仕訳帳CSV出力時の設定
instance journalOutputMyAccount :: JournalOutput MyAccount where
  printJournal = printCSVWithOrder JP.journalOrder <<< map JP.fromJournal

-- 総勘定元帳CSV出力時の設定
instance ledgerOutputMyAccount :: LedgerOutput MyAccount where
  printLedger = printCSVWithOrder JP.ledgerOrder <<< map JP.fromLedger

-- 総勘定元帳CSV出力時の設定
instance accountSummaryOutputMyAccount :: AccountSummaryOutput MyAccount where
  printAccountSummary = printCSVWithOrder JP.accountSummaryOrder <<< map JP.fromAccountSummary
