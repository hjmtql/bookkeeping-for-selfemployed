module Business.Bookkeeping.Run
  ( generateJournal
  , createGeneralLedger
  , makeTrialBalance
  , makeTrialBalanceSummary
  , makeMonthlyTrialBalance
  , makeMonthlyTrialBalanceSummary
  ) where

import Prelude
import Business.Bookkeeping.Class.Account (class Account)
import Business.Bookkeeping.Journal (mkJournals)
import Business.Bookkeeping.Transaction (Transaction)
import Business.Bookkeeping.Yearly.GeneralLedger (YearlyGeneralLedger, mkYearlyGeneralLedgers)
import Business.Bookkeeping.Yearly.Journal (YearlyJournal, mkYearlyJournals)
import Business.Bookkeeping.Yearly.Monthly.TrialBalance (YearlyMonthlyTrialBalance, mkYearlyMonthlyTrialBalance)
import Business.Bookkeeping.Yearly.Monthly.TrialBalanceSummary (YearlyMonthlyTrialBalanceSummary, mkYearlyMonthlyTrialBalanceSummary)
import Business.Bookkeeping.Yearly.TrialBalance (YearlyTrialBalance, mkYearlyTrialBalance)
import Business.Bookkeeping.Yearly.TrialBalanceSummary (YearlyTrialBalanceSummary, mkYearlyTrialBalanceSummary)
import Control.Monad.Writer (execWriter)
import Data.Either (Either)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Bounded (class GenericBottom, class GenericTop)
import Data.Generic.Rep.Enum (class GenericBoundedEnum)
import Data.List (List)

generateJournal ::
  forall c a.
  Account c a =>
  Transaction a Unit -> Either String (List (YearlyJournal a))
generateJournal tr =
  execWriter tr
    # mkJournals
    <#> mkYearlyJournals

createGeneralLedger ::
  forall c a rep.
  Account c a =>
  Generic a rep =>
  GenericTop rep =>
  GenericBottom rep =>
  GenericBoundedEnum rep =>
  List (YearlyJournal a) -> List (YearlyGeneralLedger a)
createGeneralLedger = mkYearlyGeneralLedgers

makeTrialBalance ::
  forall c a.
  Account c a =>
  List (YearlyGeneralLedger a) -> List (YearlyTrialBalance a)
makeTrialBalance = mkYearlyTrialBalance

makeTrialBalanceSummary ::
  forall c a rep.
  Account c a =>
  Generic c rep =>
  GenericTop rep =>
  GenericBottom rep =>
  GenericBoundedEnum rep =>
  List (YearlyGeneralLedger a) -> List (YearlyTrialBalanceSummary c)
makeTrialBalanceSummary = mkYearlyTrialBalanceSummary

makeMonthlyTrialBalance ::
  forall c a.
  Account c a =>
  List (YearlyGeneralLedger a) -> List (YearlyMonthlyTrialBalance a)
makeMonthlyTrialBalance = mkYearlyMonthlyTrialBalance

makeMonthlyTrialBalanceSummary ::
  forall c a rep.
  Account c a =>
  Generic c rep =>
  GenericTop rep =>
  GenericBottom rep =>
  GenericBoundedEnum rep =>
  List (YearlyGeneralLedger a) -> List (YearlyMonthlyTrialBalanceSummary c)
makeMonthlyTrialBalanceSummary = mkYearlyMonthlyTrialBalanceSummary
