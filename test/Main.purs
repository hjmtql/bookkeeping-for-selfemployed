module Test.Main where

import Prelude
import Business.Bookkeeping.Helper.Output (effEither, outputGeneralLedger, outputJournal, outputMonthlyTrialBalance, outputMonthlyTrialBalanceSummary, outputTrialBalance, outputTrialBalanceSummary)
import Business.Bookkeeping.Run (createGeneralLedger, generateJournal, makeMonthlyTrialBalance, makeMonthlyTrialBalanceSummary, makeTrialBalance, makeTrialBalanceSummary)
import Effect (Effect)
import Test.Transaction (transaction)

main :: Effect Unit
main = do
  journal <- effEither $ generateJournal transaction
  let
    generalLedger = createGeneralLedger journal

    trialBalance = makeTrialBalance generalLedger

    trialBalanceSummary = makeTrialBalanceSummary generalLedger

    monthlyTrialBalance = makeMonthlyTrialBalance generalLedger

    monthlyTrialBalanceSummary = makeMonthlyTrialBalanceSummary generalLedger
  -- 仕訳帳と総勘定元帳のCSV出力
  outputJournal journal
  outputGeneralLedger generalLedger
  -- 確定申告用の合計金額CSV出力
  outputTrialBalance trialBalance
  outputTrialBalanceSummary trialBalanceSummary
  outputMonthlyTrialBalance monthlyTrialBalance
  outputMonthlyTrialBalanceSummary monthlyTrialBalanceSummary
