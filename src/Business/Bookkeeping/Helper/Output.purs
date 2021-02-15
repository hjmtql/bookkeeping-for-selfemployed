module Business.Bookkeeping.Helper.Output where

import Prelude
import Business.Bookkeeping.Class.Account (class Account, cat)
import Business.Bookkeeping.Class.Category (categories)
import Business.Bookkeeping.Data.Monthly (monthes)
import Business.Bookkeeping.Helper.Output.Journal (class JournalOutput, printJournal)
import Business.Bookkeeping.Helper.Output.Ledger (class LedgerOutput, printLedger)
import Business.Bookkeeping.Helper.Output.TrialBalance (class TrialBalanceOutput, printTrialBalance)
import Business.Bookkeeping.Helper.Output.TrialBalanceSummary (class TrialBalanceSummaryOutput, printTrialBalanceSummary)
import Business.Bookkeeping.Helper.PathName (class PathName, pathName)
import Business.Bookkeeping.Yearly.GeneralLedger (YearlyGeneralLedger)
import Business.Bookkeeping.Yearly.Journal (YearlyJournal)
import Business.Bookkeeping.Yearly.Monthly.TrialBalance (YearlyMonthlyTrialBalance)
import Business.Bookkeeping.Yearly.Monthly.TrialBalanceSummary (YearlyMonthlyTrialBalanceSummary)
import Business.Bookkeeping.Yearly.TrialBalance (YearlyTrialBalance)
import Business.Bookkeeping.Yearly.TrialBalanceSummary (YearlyTrialBalanceSummary)
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

outputYearlyJournal ::
  forall a.
  JournalOutput a =>
  L.List (YearlyJournal a) -> Effect Unit
outputYearlyJournal yjs = do
  orMkDir pathFlags.dist
  for_ yjs \yj -> do
    out <- effEither $ printJournal yj.contents
    orMkDir $ pathJoin [ pathFlags.dist, show (fromEnum yj.year) ]
    S.writeTextFile
      UTF8
      (pathJoin [ pathFlags.dist, show (fromEnum yj.year), "journal.csv" ])
      out

outputYearlyLedger ::
  forall a c rep.
  LedgerOutput a =>
  Account c a =>
  PathName a =>
  PathName c =>
  Generic c rep =>
  GenericBottom rep =>
  GenericEnum rep =>
  L.List (YearlyGeneralLedger a) -> Effect Unit
outputYearlyLedger ygls = do
  orMkDir pathFlags.dist
  for_ ygls \ygl -> do
    orMkDir $ pathJoin [ pathFlags.dist, show (fromEnum ygl.year) ]
    orMkDir $ pathJoin [ pathFlags.dist, show (fromEnum ygl.year), pathFlags.ledger ]
    for_ (categories :: L.List c) \c ->
      orMkDir $ pathJoin [ pathFlags.dist, show (fromEnum ygl.year), pathFlags.ledger, pathName c ]
    for_ ygl.contents \gl -> do
      out <- effEither $ printLedger gl.ledgers
      S.writeTextFile
        UTF8
        (pathJoin [ pathFlags.dist, show (fromEnum ygl.year), pathFlags.ledger, pathName (cat gl.account), pathName gl.account <> ".csv" ])
        out

outputYearlyTrialBalance ::
  forall a.
  TrialBalanceOutput a =>
  L.List (YearlyTrialBalance a) -> Effect Unit
outputYearlyTrialBalance ytbs = do
  orMkDir pathFlags.dist
  for_ ytbs \ytb -> do
    out <- effEither $ printTrialBalance ytb.contents
    orMkDir $ pathJoin [ pathFlags.dist, show (fromEnum ytb.year) ]
    orMkDir $ pathJoin [ pathFlags.dist, show (fromEnum ytb.year), pathFlags.summary ]
    S.writeTextFile
      UTF8
      (pathJoin [ pathFlags.dist, show (fromEnum ytb.year), pathFlags.summary, "trialbalance.csv" ])
      out

outputYearlyTrialBalanceSummary ::
  forall c.
  TrialBalanceSummaryOutput c =>
  L.List (YearlyTrialBalanceSummary c) -> Effect Unit
outputYearlyTrialBalanceSummary ytbss = do
  orMkDir pathFlags.dist
  for_ ytbss \ytbs -> do
    out <- effEither $ printTrialBalanceSummary ytbs.contents
    orMkDir $ pathJoin [ pathFlags.dist, show (fromEnum ytbs.year) ]
    orMkDir $ pathJoin [ pathFlags.dist, show (fromEnum ytbs.year), pathFlags.summary ]
    S.writeTextFile
      UTF8
      (pathJoin [ pathFlags.dist, show (fromEnum ytbs.year), pathFlags.summary, "trialbalancesummary.csv" ])
      out

outputYearlyMonthlyTrialBalance ::
  forall a.
  TrialBalanceOutput a =>
  L.List (YearlyMonthlyTrialBalance a) -> Effect Unit
outputYearlyMonthlyTrialBalance ymtbs = do
  orMkDir pathFlags.dist
  for_ ymtbs \ymtb -> do
    orMkDir $ pathJoin [ pathFlags.dist, show (fromEnum ymtb.year) ]
    orMkDir $ pathJoin [ pathFlags.dist, show (fromEnum ymtb.year), pathFlags.summary ]
    orMkDir $ pathJoin [ pathFlags.dist, show (fromEnum ymtb.year), pathFlags.summary, pathFlags.monthly ]
    for_ monthes \m ->
      orMkDir $ pathJoin [ pathFlags.dist, show (fromEnum ymtb.year), pathFlags.summary, pathFlags.monthly, show (fromEnum m) ]
    for_ ymtb.contents \mtb -> do
      out <- effEither $ printTrialBalance mtb.balances
      S.writeTextFile
        UTF8
        (pathJoin [ pathFlags.dist, show (fromEnum ymtb.year), pathFlags.summary, pathFlags.monthly, show (fromEnum mtb.month), "trialbalance.csv" ])
        out

outputYearlyMonthlyTrialBalanceSummary ::
  forall c.
  TrialBalanceSummaryOutput c =>
  L.List (YearlyMonthlyTrialBalanceSummary c) -> Effect Unit
outputYearlyMonthlyTrialBalanceSummary ymtbss = do
  orMkDir pathFlags.dist
  for_ ymtbss \ymtbs -> do
    orMkDir $ pathJoin [ pathFlags.dist, show (fromEnum ymtbs.year) ]
    orMkDir $ pathJoin [ pathFlags.dist, show (fromEnum ymtbs.year), pathFlags.summary ]
    orMkDir $ pathJoin [ pathFlags.dist, show (fromEnum ymtbs.year), pathFlags.summary, pathFlags.monthly ]
    for_ monthes \m ->
      orMkDir $ pathJoin [ pathFlags.dist, show (fromEnum ymtbs.year), pathFlags.summary, pathFlags.monthly, show (fromEnum m) ]
    for_ ymtbs.contents \mtbs -> do
      out <- effEither $ printTrialBalanceSummary mtbs.balances
      S.writeTextFile
        UTF8
        (pathJoin [ pathFlags.dist, show (fromEnum ymtbs.year), pathFlags.summary, pathFlags.monthly, show (fromEnum mtbs.month), "trialbalancesummary.csv" ])
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
