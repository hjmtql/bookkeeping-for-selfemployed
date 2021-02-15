module Test.Main where

import Prelude
import Business.Bookkeeping.Helper.Output (effEither, outputYearlyJournal, outputYearlyLedger, outputYearlyMonthlyTrialBalance, outputYearlyMonthlyTrialBalanceSummary, outputYearlyTrialBalance, outputYearlyTrialBalanceSummary)
import Business.Bookkeeping.Run (generateJournal)
import Business.Bookkeeping.Transaction (Transaction, day, item, month, multipleD, single, year)
import Business.Bookkeeping.Yearly.GeneralLedger (mkYearlyGeneralLedgers)
import Business.Bookkeeping.Yearly.Journal (mkYearlyJournals)
import Business.Bookkeeping.Yearly.Monthly.TrialBalance (mkYearlyMonthlyTrialBalance)
import Business.Bookkeeping.Yearly.Monthly.TrialBalanceSummary (mkYearlyMonthlyTrialBalanceSummary)
import Business.Bookkeeping.Yearly.TrialBalance (mkYearlyTrialBalance)
import Business.Bookkeeping.Yearly.TrialBalanceSummary (mkYearlyTrialBalanceSummary)
import Effect (Effect)
import Test.MyAccount (MyAccount(..))

-- 取引の記録
transaction :: Transaction MyAccount Unit
transaction = do
  year 2019 do
    month 6 do day 1 do sales "zzzデザイン" 50_000
  year 2020 do
    rent
    month 2 do
      day 15 do
        -- 複数借方の取引（1toNの複合仕訳）
        multipleD
          { summary: "名刺作成"
          , debits:
              item { account: Supplies, amount: 5_000 }
                <> item { account: Commission, amount: 200 }
          , credit: WithdrawalsByOwner
          }
      day 20 do
        sales "xxxコーディング" 100_000
    month 3 do
      day 10 do
        sales "yyyサーバー構築" 200_000
  where
  -- 売上
  sales s a =
    single
      { summary: s
      , debit: WithdrawalsByOwner
      , credit: Sales
      , amount: a
      }

  -- 家賃（定常的な経費）
  rent = do
    month 1 $ day 25 $ _家賃按分5割 "1月分" 25_000
    month 2 $ day 25 $ _家賃按分5割 "2月分" 25_000
    month 3 $ day 25 $ _家賃按分5割 "3月分" 25_000
    where
    _家賃按分5割 when amount =
      single
        { summary: "家賃按分5割" <> when
        , debit: Rent
        , credit: WithdrawalsByOwner
        , amount: amount
        }

main :: Effect Unit
main = do
  -- 仕訳帳と総勘定元帳のCSV出力
  journals <- effEither $ generateJournal transaction
  let
    yearlyJournals = mkYearlyJournals journals

    yearlyGeneralLedgers = mkYearlyGeneralLedgers yearlyJournals
  outputYearlyJournal yearlyJournals
  outputYearlyLedger yearlyGeneralLedgers
  -- 確定申告用の合計金額CSV出力
  let
    yearlyTrialBalance = mkYearlyTrialBalance yearlyGeneralLedgers

    yearlyTrialBalanceSummary = mkYearlyTrialBalanceSummary yearlyGeneralLedgers

    yearlyMonthlyTrialBalance = mkYearlyMonthlyTrialBalance yearlyGeneralLedgers

    yearlyMonthlyTrialBalanceSummary = mkYearlyMonthlyTrialBalanceSummary yearlyGeneralLedgers
  outputYearlyTrialBalance yearlyTrialBalance
  outputYearlyTrialBalanceSummary yearlyTrialBalanceSummary
  outputYearlyMonthlyTrialBalance yearlyMonthlyTrialBalance
  outputYearlyMonthlyTrialBalanceSummary yearlyMonthlyTrialBalanceSummary
