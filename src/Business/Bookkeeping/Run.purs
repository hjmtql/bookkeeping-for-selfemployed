module Business.Bookkeeping.Run
  ( generateJournal
  , generateLedger
  , outputJournal
  , outputLedger
  ) where

import Prelude
import Business.Bookkeeping.Class.Account (class Account, accounts, cat)
import Business.Bookkeeping.Data.Category (categories)
import Business.Bookkeeping.GeneralLedger (GeneralLedger, mkGeneralLedger)
import Business.Bookkeeping.Journal (Journal, mkJournals)
import Business.Bookkeeping.Transaction (Transaction)
import Control.Monad.Writer (execWriter)
import Data.Foldable (for_)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Bounded (class GenericBottom)
import Data.Generic.Rep.Enum (class GenericEnum)
import Data.List as L
import Data.String (joinWith)
import Effect (Effect)
import Node.Encoding (Encoding(..))
import Node.FS.Sync as S
import Record.CSV.Printer (printCSV)

generateJournal ::
  forall a.
  Account a =>
  Transaction a Unit -> L.List (Journal a)
generateJournal = mkJournals <<< execWriter

generateLedger ::
  forall a b.
  Generic a b =>
  GenericBottom b =>
  GenericEnum b =>
  Account a =>
  L.List (Journal a) -> L.List (GeneralLedger a)
generateLedger js = flip mkGeneralLedger js <$> accounts

outputJournal :: forall a. Account a => L.List (Journal a) -> Effect Unit
outputJournal js = do
  isDir <- S.exists paths.top
  when (not isDir) $ S.mkdir paths.top
  S.writeTextFile
    UTF8
    (pathJoin [ paths.top, "journal.csv" ])
    (printCSV js)

outputLedger :: forall a. Account a => L.List (GeneralLedger a) -> Effect Unit
outputLedger gs = do
  isDir <- S.exists paths.top
  when (not isDir) $ S.mkdir paths.top
  S.mkdir $ pathJoin [ paths.top, paths.sub ]
  for_ categories \c -> do
    S.mkdir $ pathJoin [ paths.top, paths.sub, show c ]
  for_ gs \g -> do
    S.writeTextFile
      UTF8
      (pathJoin [ paths.top, paths.sub, show $ cat g.account, show g.account <> ".csv" ])
      (printCSV g.ledgers)

pathJoin :: Array String -> String
pathJoin = joinWith "/"

paths ::
  { top :: String
  , sub :: String
  }
paths =
  { top: "dist"
  , sub: "ledger"
  }
