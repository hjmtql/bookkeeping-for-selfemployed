module Business.Bookkeeping.Helper.Output.EN.TrialBalance where

import Business.Bookkeeping.Class.Account (class Account)
import Business.Bookkeeping.TrialBalance (TrialBalance)
import Data.Maybe (Maybe)
import Record.CSV.Printer.SList (type (!), type (:), SLProxy(..))

type ENTrialBalance a
  = { "Account" :: a
    , "Debit Total" :: Maybe Int
    , "Credit Total" :: Maybe Int
    , "Debit Balance" :: Maybe Int
    , "Credit Balance" :: Maybe Int
    }

fromTrialBalance :: forall c a. Account c a => TrialBalance a -> ENTrialBalance a
fromTrialBalance tb =
  { "Account": tb.account
  , "Debit Total": tb.debitTotal
  , "Credit Total": tb.creditTotal
  , "Debit Balance": tb.debitBalance
  , "Credit Balance": tb.creditBalance
  }

type ENTrialBalanceHeaderOrder
  = "Account"
      : "Debit Total"
      : "Credit Total"
      : "Debit Balance"
      ! "Credit Balance"

trialBalanceOrder :: SLProxy ENTrialBalanceHeaderOrder
trialBalanceOrder = SLProxy
