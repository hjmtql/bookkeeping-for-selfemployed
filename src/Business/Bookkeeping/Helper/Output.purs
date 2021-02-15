module Business.Bookkeeping.Helper.Output where

import Prelude
import Business.Bookkeeping.Class.Account (class Account, cat)
import Business.Bookkeeping.Class.Category (categories)
import Business.Bookkeeping.Data.Monthly (monthes)
import Business.Bookkeeping.GeneralLedger (GeneralLedger)
import Business.Bookkeeping.Helper.Output.Journal (class JournalOutput, printJournal)
import Business.Bookkeeping.Helper.Output.Ledger (class LedgerOutput, printLedger)
import Business.Bookkeeping.Helper.Output.TrialBalance (class TrialBalanceOutput, printTrialBalance)
import Business.Bookkeeping.Helper.Output.TrialBalanceSummary (class TrialBalanceSummaryOutput, printTrialBalanceSummary)
import Business.Bookkeeping.Helper.PathName (class PathName, pathName)
import Business.Bookkeeping.Journal (Journal)
import Business.Bookkeeping.Monthly.TrialBalance (MonthlyTrialBalance)
import Business.Bookkeeping.Monthly.TrialBalanceSummary (MonthlyTrialBalanceSummary)
import Business.Bookkeeping.TrialBalance (TrialBalance)
import Business.Bookkeeping.TrialBalanceSummary (TrialBalanceSummary)
import Data.Either (Either(..))
import Data.Enum (fromEnum)
import Data.Foldable (for_)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Bounded (class GenericBottom)
import Data.Generic.Rep.Enum (class GenericEnum)
import Data.List as L
import Data.String (joinWith)
import Effect (Effect)
import Effect.Exception (throw)
import Node.Encoding (Encoding(..))
import Node.FS.Sync as S

outputJournal ::
  forall a.
  JournalOutput a =>
  L.List (Journal a) -> Effect Unit
outputJournal js = do
  out <- effEither $ printJournal js
  orMkDir dirs.dist
  S.writeTextFile
    UTF8
    (pathJoin [ dirs.dist, "journal.csv" ])
    out

outputLedger ::
  forall a c rep.
  LedgerOutput a =>
  Account c a =>
  PathName a =>
  PathName c =>
  Generic c rep =>
  GenericBottom rep =>
  GenericEnum rep =>
  L.List (GeneralLedger a) -> Effect Unit
outputLedger gs = do
  orMkDir dirs.dist
  orMkDir dirs.ledger
  for_ (categories :: L.List c) \c ->
    orMkDir $ pathJoin [ dirs.ledger, pathName c ]
  for_ gs \g -> do
    out <- effEither $ printLedger g.ledgers
    S.writeTextFile
      UTF8
      (pathJoin [ dirs.ledger, pathName (cat g.account), pathName g.account <> ".csv" ])
      out

outputTrialBalance ::
  forall a.
  TrialBalanceOutput a =>
  L.List (TrialBalance a) -> Effect Unit
outputTrialBalance tbs = do
  out <- effEither $ printTrialBalance tbs
  orMkDir dirs.dist
  orMkDir dirs.summary
  S.writeTextFile
    UTF8
    (pathJoin [ dirs.summary, "trialbalance.csv" ])
    out

outputTrialBalanceSummary ::
  forall c.
  TrialBalanceSummaryOutput c =>
  L.List (TrialBalanceSummary c) -> Effect Unit
outputTrialBalanceSummary tbss = do
  out <- effEither $ printTrialBalanceSummary tbss
  orMkDir dirs.dist
  orMkDir dirs.summary
  S.writeTextFile
    UTF8
    (pathJoin [ dirs.summary, "trialbalancesummary.csv" ])
    out

outputMonthlyTrialBalance ::
  forall a.
  TrialBalanceOutput a =>
  L.List (MonthlyTrialBalance a) -> Effect Unit
outputMonthlyTrialBalance mtbs = do
  orMkDir dirs.dist
  orMkDir dirs.summary
  orMkDir dirs.monthly
  for_ monthes \m ->
    orMkDir $ pathJoin [ dirs.monthly, show (fromEnum m) ]
  for_ mtbs \mtb -> do
    out <- effEither $ printTrialBalance mtb.balances
    S.writeTextFile
      UTF8
      (pathJoin [ dirs.monthly, show (fromEnum mtb.month), "trialbalance.csv" ])
      out

outputMonthlyTrialBalanceSummary ::
  forall c.
  TrialBalanceSummaryOutput c =>
  L.List (MonthlyTrialBalanceSummary c) -> Effect Unit
outputMonthlyTrialBalanceSummary mtbss = do
  orMkDir dirs.dist
  orMkDir dirs.summary
  orMkDir dirs.monthly
  for_ monthes \m ->
    orMkDir $ pathJoin [ dirs.monthly, show (fromEnum m) ]
  for_ mtbss \mtbs -> do
    out <- effEither $ printTrialBalanceSummary mtbs.balances
    S.writeTextFile
      UTF8
      (pathJoin [ dirs.monthly, show (fromEnum mtbs.month), "trialbalancesummary.csv" ])
      out

effEither :: forall a b. Show a => Either a b -> Effect b
effEither = case _ of
  Right s -> pure s
  Left e -> throw $ show e

orMkDir :: String -> Effect Unit
orMkDir path = do
  isDir <- S.exists path
  when (not isDir) $ S.mkdir path

pathJoin :: Array String -> String
pathJoin = joinWith "/"

pathFlags ::
  { dist :: String
  , ledger :: String
  , summary :: String
  , monthly :: String
  }
pathFlags =
  { dist: "dist"
  , ledger: "ledger"
  , summary: "summary"
  , monthly: "monthly"
  }

dirs ::
  { dist :: String
  , ledger :: String
  , monthly :: String
  , summary :: String
  }
dirs =
  { dist: pathFlags.dist
  , ledger: pathJoin [ pathFlags.dist, pathFlags.ledger ]
  , summary: pathJoin [ pathFlags.dist, pathFlags.summary ]
  , monthly: pathJoin [ pathFlags.dist, pathFlags.summary, pathFlags.monthly ]
  }
