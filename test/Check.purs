module Test.Check where

import Prelude
import Business.Bookkeeping.Data.Summary (TrialBalanceR, plus)
import Business.Bookkeeping.Helper.Output (effEither)
import Business.Bookkeeping.Run (createGeneralLedger, generateJournal, makeMonthlyTrialBalance, makeMonthlyTrialBalanceSummary, makeTrialBalance, makeTrialBalanceSummary)
import Business.Bookkeeping.Type (Money)
import Data.Enum (fromEnum)
import Data.Foldable (foldr, for_, sum)
import Data.List (List, concatMap, filter, zip)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Tuple (uncurry)
import Effect (Effect)
import Effect.Class.Console (log)
import Test.Transaction (transaction)
import Test.Unit (suite, test)
import Test.Unit.Assert (equal)
import Test.Unit.Main (runTest)

main :: Effect Unit
main = do
  journal <- effEither $ generateJournal transaction
  let
    generalLedger = createGeneralLedger journal

    trialBalance = makeTrialBalance generalLedger

    trialBalanceSummary = makeTrialBalanceSummary generalLedger

    monthlyTrialBalance = makeMonthlyTrialBalance generalLedger

    monthlyTrialBalanceSummary = makeMonthlyTrialBalanceSummary generalLedger
  runTest do
    suite "total debit and total credit are equal" do
      test "trial balances" do
        for_ trialBalance \ytb -> do
          let
            totals = foldTrialBalance ytb.contents
          log $ show (fromEnum ytb.year)
          equal totals.debitTotal totals.creditTotal
          equal totals.debitBalance totals.creditBalance
      test "trial balance summaries" do
        for_ trialBalanceSummary \ytbs -> do
          let
            totals = foldTrialBalance ytbs.contents
          log $ show (fromEnum ytbs.year)
          equal totals.debitTotal totals.creditTotal
          equal totals.debitBalance totals.creditBalance
      test "monthly trial balances" do
        for_ monthlyTrialBalance \ymtb -> do
          for_ ymtb.contents \mtb -> do
            let
              totals = foldTrialBalance mtb.balances
            log $ show (fromEnum ymtb.year) <> " " <> show (fromEnum mtb.month)
            equal totals.debitTotal totals.creditTotal
            equal totals.debitBalance totals.creditBalance
      test "monthly trial balance summaries" do
        for_ monthlyTrialBalanceSummary \ymtbs -> do
          for_ ymtbs.contents \mtbs -> do
            let
              totals = foldTrialBalance mtbs.balances
            log $ show (fromEnum ymtbs.year) <> " " <> show (fromEnum mtbs.month)
            equal totals.debitTotal totals.creditTotal
            equal totals.debitBalance totals.creditBalance
    suite "total debit/credit are equal" do
      test "general ledger total and trial balance" do
        zipFor_ generalLedger trialBalance \ygl ytb -> do
          equal ygl.year ytb.year
          zipFor_ ygl.contents ytb.contents \gl tb -> do
            equal gl.account tb.account
            let
              debitTotal = foldAmount _.debitAmount gl.ledgers

              creditTotal = foldAmount _.creditAmount gl.ledgers
            log $ show (fromEnum ygl.year) <> " " <> show gl.account
            equal debitTotal tb.debitTotal
            equal creditTotal tb.creditTotal
      test "trial balance and trial balance summary" do
        zipFor_ trialBalance trialBalanceSummary \ytb ytbs -> do
          equal ytb.year ytbs.year
          let
            tbTotals = foldTrialBalance ytb.contents

            tbsTotals = foldTrialBalance ytbs.contents
          log $ show (fromEnum ytb.year)
          equal tbTotals tbsTotals
      test "monthly trial balance and monthly trial balance summary" do
        zipFor_ monthlyTrialBalance monthlyTrialBalanceSummary \ymtb ymtbs -> do
          equal ymtb.year ymtbs.year
          zipFor_ ymtb.contents ymtbs.contents \mtb mtbs -> do
            equal mtb.month mtbs.month
            let
              mtbTotals = foldTrialBalance mtb.balances

              mtbsTotals = foldTrialBalance mtbs.balances
            log $ show (fromEnum ymtb.year) <> " " <> show (fromEnum mtb.month)
            equal mtbTotals mtbsTotals
      test "monthly trial balance and trial balance" do
        zipFor_ monthlyTrialBalance trialBalance \ymtb ytb -> do
          equal ymtb.year ytb.year
          for_ ytb.contents \tb -> do
            let
              mtbTotals =
                ymtb.contents
                  # concatMap _.balances
                  # filter (\mtb -> mtb.account == tb.account)
                  # foldTrialBalance
            log $ show (fromEnum ymtb.year) <> " " <> show tb.account
            equal mtbTotals.debitTotal tb.debitTotal
            equal mtbTotals.creditTotal tb.creditTotal
      test "monthly trial balance summary and trial balance summary" do
        zipFor_ monthlyTrialBalanceSummary trialBalanceSummary \ymtbs ytbs -> do
          equal ymtbs.year ytbs.year
          for_ ytbs.contents \tbs -> do
            let
              mtbsTotals =
                ymtbs.contents
                  # concatMap _.balances
                  # filter (\mtb -> mtb.category == tbs.category)
                  # foldTrialBalance
            log $ show (fromEnum ymtbs.year) <> " " <> show tbs.category
            equal mtbsTotals.debitTotal tbs.debitTotal
            equal mtbsTotals.creditTotal tbs.creditTotal
      test "journal and trial balance and trial balance (trial balance summary)" do
        zipFor_ journal trialBalance \yj ytb -> do
          equal yj.year ytb.year
          let
            total = sum $ map _.amount yj.contents

            tbTotals = foldTrialBalance ytb.contents
          log $ show (fromEnum ytb.year)
          equal total $ or0 tbTotals.debitTotal
          equal total $ or0 tbTotals.creditTotal

zipFor_ ::
  forall a b f.
  Applicative f =>
  List a -> List b -> (a -> b -> f Unit) -> f Unit
zipFor_ a b = for_ (zip a b) <<< uncurry

foldAmount :: forall r. ({ | r } -> Maybe Money) -> List { | r } -> Maybe Money
foldAmount prop = foldr (plus <<< prop) Nothing

foldTrialBalance :: forall r. List (TrialBalanceR r) -> TrialBalanceR ()
foldTrialBalance xs =
  { debitTotal: foldAmount _.debitTotal xs
  , creditTotal: foldAmount _.creditTotal xs
  , debitBalance: foldAmount _.debitBalance xs
  , creditBalance: foldAmount _.creditBalance xs
  }

or0 :: Maybe Money -> Money
or0 = fromMaybe 0
