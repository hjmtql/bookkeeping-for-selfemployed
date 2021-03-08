module Business.Bookkeeping.Helper.Output
  ( outputJournal
  , outputGeneralLedger
  , outputTrialBalance
  , outputTrialBalanceSummary
  , outputMonthlyTrialBalance
  , outputMonthlyTrialBalanceSummary
  , effEither
  ) where

import Prelude
import Business.Bookkeeping.Class.Account (class Account, cat)
import Business.Bookkeeping.Class.Category (categories)
import Business.Bookkeeping.Data.Monthly (months)
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
import Data.Bounded.Generic (class GenericBottom, class GenericTop)
import Data.Either (Either(..))
import Data.Enum (class BoundedEnum, fromEnum)
import Data.Enum.Generic (class GenericBoundedEnum)
import Data.Foldable (for_)
import Data.Generic.Rep (class Generic)
import Data.List as L
import Data.String (joinWith)
import Effect (Effect)
import Effect.Exception (throw)
import Node.Encoding (Encoding(..))
import Node.FS.Sync as S

outputJournal ::
  forall a.
  JournalOutput a =>
  L.List (YearlyJournal a) -> Effect Unit
outputJournal yjs = do
  orMkDir pathFlags.dist
  for_ yjs \yj -> do
    orMkDir $ pathJoin [ pathFlags.dist, showEnum yj.year ]
    S.writeTextFile
      UTF8
      (pathJoin [ pathFlags.dist, showEnum yj.year, fileNames.journal ])
      (printJournal yj.contents)

outputGeneralLedger ::
  forall a c rep.
  LedgerOutput a =>
  Account c a =>
  PathName a =>
  PathName c =>
  Generic c rep =>
  GenericTop rep =>
  GenericBottom rep =>
  GenericBoundedEnum rep =>
  L.List (YearlyGeneralLedger a) -> Effect Unit
outputGeneralLedger ygls = do
  orMkDir pathFlags.dist
  for_ ygls \ygl -> do
    orMkDir $ pathJoin [ pathFlags.dist, showEnum ygl.year ]
    orMkDir $ pathJoin [ pathFlags.dist, showEnum ygl.year, pathFlags.ledger ]
    for_ (categories :: L.List c) \c ->
      orMkDir $ pathJoin [ pathFlags.dist, showEnum ygl.year, pathFlags.ledger, pathName c ]
    for_ ygl.contents \gl ->
      S.writeTextFile
        UTF8
        (pathJoin [ pathFlags.dist, showEnum ygl.year, pathFlags.ledger, pathName (cat gl.account), csvExt (pathName gl.account) ])
        (printLedger gl.ledgers)

outputTrialBalance ::
  forall a.
  TrialBalanceOutput a =>
  L.List (YearlyTrialBalance a) -> Effect Unit
outputTrialBalance ytbs = do
  orMkDir pathFlags.dist
  for_ ytbs \ytb -> do
    orMkDir $ pathJoin [ pathFlags.dist, showEnum ytb.year ]
    orMkDir $ pathJoin [ pathFlags.dist, showEnum ytb.year, pathFlags.summary ]
    S.writeTextFile
      UTF8
      (pathJoin [ pathFlags.dist, showEnum ytb.year, pathFlags.summary, fileNames.trialBalance ])
      (printTrialBalance ytb.contents)

outputTrialBalanceSummary ::
  forall c.
  TrialBalanceSummaryOutput c =>
  L.List (YearlyTrialBalanceSummary c) -> Effect Unit
outputTrialBalanceSummary ytbss = do
  orMkDir pathFlags.dist
  for_ ytbss \ytbs -> do
    orMkDir $ pathJoin [ pathFlags.dist, showEnum ytbs.year ]
    orMkDir $ pathJoin [ pathFlags.dist, showEnum ytbs.year, pathFlags.summary ]
    S.writeTextFile
      UTF8
      (pathJoin [ pathFlags.dist, showEnum ytbs.year, pathFlags.summary, fileNames.trialBalanceSummary ])
      (printTrialBalanceSummary ytbs.contents)

outputMonthlyTrialBalance ::
  forall a.
  TrialBalanceOutput a =>
  L.List (YearlyMonthlyTrialBalance a) -> Effect Unit
outputMonthlyTrialBalance ymtbs = do
  orMkDir pathFlags.dist
  for_ ymtbs \ymtb -> do
    orMkDir $ pathJoin [ pathFlags.dist, showEnum ymtb.year ]
    orMkDir $ pathJoin [ pathFlags.dist, showEnum ymtb.year, pathFlags.summary ]
    orMkDir $ pathJoin [ pathFlags.dist, showEnum ymtb.year, pathFlags.summary, pathFlags.monthly ]
    for_ months \m ->
      orMkDir $ pathJoin [ pathFlags.dist, showEnum ymtb.year, pathFlags.summary, pathFlags.monthly, showEnum m ]
    for_ ymtb.contents \mtb ->
      S.writeTextFile
        UTF8
        (pathJoin [ pathFlags.dist, showEnum ymtb.year, pathFlags.summary, pathFlags.monthly, showEnum mtb.month, fileNames.trialBalance ])
        (printTrialBalance mtb.balances)

outputMonthlyTrialBalanceSummary ::
  forall c.
  TrialBalanceSummaryOutput c =>
  L.List (YearlyMonthlyTrialBalanceSummary c) -> Effect Unit
outputMonthlyTrialBalanceSummary ymtbss = do
  orMkDir pathFlags.dist
  for_ ymtbss \ymtbs -> do
    orMkDir $ pathJoin [ pathFlags.dist, showEnum ymtbs.year ]
    orMkDir $ pathJoin [ pathFlags.dist, showEnum ymtbs.year, pathFlags.summary ]
    orMkDir $ pathJoin [ pathFlags.dist, showEnum ymtbs.year, pathFlags.summary, pathFlags.monthly ]
    for_ months \m ->
      orMkDir $ pathJoin [ pathFlags.dist, showEnum ymtbs.year, pathFlags.summary, pathFlags.monthly, showEnum m ]
    for_ ymtbs.contents \mtbs ->
      S.writeTextFile
        UTF8
        (pathJoin [ pathFlags.dist, showEnum ymtbs.year, pathFlags.summary, pathFlags.monthly, showEnum mtbs.month, fileNames.trialBalanceSummary ])
        (printTrialBalanceSummary mtbs.balances)

effEither :: forall a b. Show a => Either a b -> Effect b
effEither = case _ of
  Right s -> pure s
  Left e -> throw $ show e

orMkDir :: String -> Effect Unit
orMkDir path = do
  isDir <- S.exists path
  when (not isDir) $ S.mkdir path

showEnum :: forall a. BoundedEnum a => a -> String
showEnum = show <<< fromEnum

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

csvExt :: String -> String
csvExt fn = fn <> ".csv"

fileNames ::
  { journal :: String
  , trialBalance :: String
  , trialBalanceSummary :: String
  }
fileNames =
  { journal: csvExt "journal"
  , trialBalance: csvExt "trialBalance"
  , trialBalanceSummary: csvExt "trialBalanceSummary"
  }
