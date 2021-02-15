module Business.Bookkeeping.Helper.Output.JP.TrialBalanceSummary where

import Business.Bookkeeping.Class.Category (class AccountCategory)
import Business.Bookkeeping.TrialBalanceSummary (TrialBalanceSummary)
import Data.Maybe (Maybe)
import Record.CSV.Printer.SList (type (!), type (:), SLProxy(..))

type JPTrialBalanceSummary c
  = { "勘定科目分類" :: c
    , "借方合計" :: Maybe Int
    , "貸方合計" :: Maybe Int
    , "借方残高" :: Maybe Int
    , "貸方残高" :: Maybe Int
    }

fromTrialBalanceSummary :: forall c. AccountCategory c => TrialBalanceSummary c -> JPTrialBalanceSummary c
fromTrialBalanceSummary tbs =
  { "勘定科目分類": tbs.category
  , "借方合計": tbs.debitTotal
  , "貸方合計": tbs.creditTotal
  , "借方残高": tbs.debitBalance
  , "貸方残高": tbs.creditBalance
  }

type JPTrialBalanceSummaryHeaderOrder
  = "勘定科目分類"
      : "借方合計"
      : "貸方合計"
      : "借方残高"
      ! "貸方残高"

trialBalanceSummaryOrder :: SLProxy JPTrialBalanceSummaryHeaderOrder
trialBalanceSummaryOrder = SLProxy
