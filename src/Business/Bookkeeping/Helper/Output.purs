module Business.Bookkeeping.Helper.Output where

import Prelude
import Business.Bookkeeping.AccountSummary (AccountSummary)
import Business.Bookkeeping.CategorySummary (CategorySummary)
import Business.Bookkeeping.Class.Account (class Account, cat)
import Business.Bookkeeping.Class.Category (categories)
import Business.Bookkeeping.GeneralLedger (GeneralLedger)
import Business.Bookkeeping.Helper.Output.AccountSummary (class AccountSummaryOutput, printAccountSummary)
import Business.Bookkeeping.Helper.Output.CategorySummary (class CategorySummaryOutput, printCategorySummary)
import Business.Bookkeeping.Helper.Output.Journal (class JournalOutput, printJournal)
import Business.Bookkeeping.Helper.Output.Ledger (class LedgerOutput, printLedger)
import Business.Bookkeeping.Helper.PathName (class PathName, pathName)
import Business.Bookkeeping.Journal (Journal)
import Data.Either (Either(..))
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
  orMkDir paths.top
  S.writeTextFile
    UTF8
    (pathJoin [ paths.top, "journal.csv" ])
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
  orMkDir paths.top
  orMkDir $ pathJoin [ paths.top, paths.sub ]
  for_ (categories :: L.List c) \c ->
    orMkDir $ pathJoin [ paths.top, paths.sub, pathName c ]
  for_ gs \g -> do
    out <- effEither $ printLedger g.ledgers
    S.writeTextFile
      UTF8
      (pathJoin [ paths.top, paths.sub, pathName (cat g.account), pathName g.account <> ".csv" ])
      out

outputAccountSummary ::
  forall a.
  AccountSummaryOutput a =>
  L.List (AccountSummary a) -> Effect Unit
outputAccountSummary ass = do
  out <- effEither $ printAccountSummary ass
  orMkDir paths.top
  orMkDir $ pathJoin [ paths.top, paths.sum ]
  S.writeTextFile
    UTF8
    (pathJoin [ paths.top, paths.sum, "account.csv" ])
    out

outputCategorySummary ::
  forall c.
  CategorySummaryOutput c =>
  L.List (CategorySummary c) -> Effect Unit
outputCategorySummary css = do
  out <- effEither $ printCategorySummary css
  orMkDir paths.top
  orMkDir $ pathJoin [ paths.top, paths.sum ]
  S.writeTextFile
    UTF8
    (pathJoin [ paths.top, paths.sum, "category.csv" ])
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

paths ::
  { top :: String
  , sub :: String
  , sum :: String
  }
paths =
  { top: "dist"
  , sub: "ledger"
  , sum: "summary"
  }
