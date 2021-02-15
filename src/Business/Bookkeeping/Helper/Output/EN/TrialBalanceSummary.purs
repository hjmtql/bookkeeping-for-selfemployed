module Business.Bookkeeping.Helper.Output.EN.TrialBalanceSummary where

import Business.Bookkeeping.Class.Category (class AccountCategory)
import Business.Bookkeeping.TrialBalanceSummary (TrialBalanceSummary)
import Data.Maybe (Maybe)
import Record.CSV.Printer.SList (type (!), type (:), SLProxy(..))

type ENTrialBalanceSummary c
  = { "Category" :: c
    , "Debit Total" :: Maybe Int
    , "Credit Total" :: Maybe Int
    , "Debit Balance" :: Maybe Int
    , "Credit Balance" :: Maybe Int
    }

fromTrialBalanceSummary :: forall c. AccountCategory c => TrialBalanceSummary c -> ENTrialBalanceSummary c
fromTrialBalanceSummary tbs =
  { "Category": tbs.category
  , "Debit Total": tbs.debitTotal
  , "Credit Total": tbs.creditTotal
  , "Debit Balance": tbs.debitBalance
  , "Credit Balance": tbs.creditBalance
  }

type ENTrialBalanceSummaryHeaderOrder
  = "Category"
      : "Debit Total"
      : "Credit Total"
      : "Debit Balance"
      ! "Credit Balance"

trialBalanceSummaryOrder :: SLProxy ENTrialBalanceSummaryHeaderOrder
trialBalanceSummaryOrder = SLProxy
