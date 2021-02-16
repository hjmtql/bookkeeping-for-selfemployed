module Test.Main where

import Prelude
import Business.Bookkeeping.Helper.Output (effEither, outputGeneralLedger, outputJournal, outputMonthlyTrialBalance, outputMonthlyTrialBalanceSummary, outputTrialBalance, outputTrialBalanceSummary)
import Business.Bookkeeping.Run (createGeneralLedger, generateJournal, makeMonthlyTrialBalance, makeMonthlyTrialBalanceSummary, makeTrialBalance, makeTrialBalanceSummary)
import Business.Bookkeeping.Transaction (Transaction, day, item, month, multipleC, multipleD, single, year)
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
      day 18 do
        -- 複数貸方の取引（1toNの複合仕訳）
        multipleC
          { summary: "PC買掛"
          , debit: Supplies
          , credits:
              item { account: WithdrawalsByOwner, amount: 100_000 }
                <> item { account: AccountsPayable, amount: 50_000 }
          }
      day 20 do
        sales "xxxコーディング" 100_000
    month 3 do
      day 10 do
        sales "yyyサーバー構築" 200_000
      day 30 do
        expense "PC買掛完了" AccountsPayable 50_000
  where
  -- 売上
  sales s a =
    single
      { summary: s
      , debit: WithdrawalsByOwner
      , credit: Sales
      , amount: a
      }

  -- 経費
  expense s e a =
    single
      { summary: s
      , debit: e
      , credit: WithdrawalsByOwner
      , amount: a
      }

  -- 家賃（定常的な経費）
  rent = do
    month 1 $ day 25 $ _家賃按分5割 "1月分" 25_000
    month 2 $ day 25 $ _家賃按分5割 "2月分" 25_000
    month 3 $ day 25 $ _家賃按分5割 "3月分" 25_000
    where
    _家賃按分5割 when = expense ("家賃按分5割" <> when) Rent

main :: Effect Unit
main = do
  journal <- effEither $ generateJournal transaction
  let
    generalLedger = createGeneralLedger journal

    trialBalance = makeTrialBalance generalLedger

    trialBalanceSummary = makeTrialBalanceSummary generalLedger

    mnthlyTrialBalance = makeMonthlyTrialBalance generalLedger

    mnthlyTrialBalanceSummary = makeMonthlyTrialBalanceSummary generalLedger
  -- 仕訳帳と総勘定元帳のCSV出力
  outputJournal journal
  outputGeneralLedger generalLedger
  -- 確定申告用の合計金額CSV出力
  outputTrialBalance trialBalance
  outputTrialBalanceSummary trialBalanceSummary
  outputMonthlyTrialBalance mnthlyTrialBalance
  outputMonthlyTrialBalanceSummary mnthlyTrialBalanceSummary
