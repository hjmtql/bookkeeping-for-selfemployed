module Business.Bookkeeping.Helper.Output.JP.TrialBalance where

import Business.Bookkeeping.Class.Account (class Account)
import Business.Bookkeeping.TrialBalance (TrialBalance)
import Data.Maybe (Maybe)
import Record.CSV.Printer.SList (type (!), type (:), SLProxy(..))

type JPTrialBalance a
  = { "勘定科目" :: a
    , "借方合計" :: Maybe Int
    , "貸方合計" :: Maybe Int
    , "借方残高" :: Maybe Int
    , "貸方残高" :: Maybe Int
    }

fromTrialBalance :: forall c a. Account c a => TrialBalance a -> JPTrialBalance a
fromTrialBalance tb =
  { "勘定科目": tb.account
  , "借方合計": tb.debitTotal
  , "貸方合計": tb.creditTotal
  , "借方残高": tb.debitBalance
  , "貸方残高": tb.creditBalance
  }

type JPTrialBalanceHeaderOrder
  = "勘定科目"
      : "借方合計"
      : "貸方合計"
      : "借方残高"
      ! "貸方残高"

trialBalanceOrder :: SLProxy JPTrialBalanceHeaderOrder
trialBalanceOrder = SLProxy
