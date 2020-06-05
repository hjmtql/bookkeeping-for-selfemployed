module Test.Output where

import Prelude
import Business.Bookkeeping.Class.Account (cat)
import Business.Bookkeeping.Data.Category (categories)
import Business.Bookkeeping.GeneralLedger (GeneralLedger)
import Business.Bookkeeping.Journal (Journal)
import Data.Either (Either(..))
import Data.Foldable (for_)
import Data.List as L
import Data.String (joinWith)
import Effect (Effect)
import Effect.Exception (throw)
import Node.Encoding (Encoding(..))
import Node.FS.Sync as S
import Record.CSV.Printer (printCSVWithOrder)
import Test.MyAccount (MyAccount)
import Test.MyJournal (fromJournal, journalOrder)
import Test.MyLedger (fromLedger, ledgerOrder)
import Test.PathName (pathName)

outputJournal :: L.List (Journal MyAccount) -> Effect Unit
outputJournal js = do
  out <- effEither $ printCSVWithOrder journalOrder myjs
  orMkDir paths.top
  S.writeTextFile
    UTF8
    (pathJoin [ paths.top, "journal.csv" ])
    out
  where
  myjs = map fromJournal js

outputLedger :: L.List (GeneralLedger MyAccount) -> Effect Unit
outputLedger gs = do
  orMkDir paths.top
  orMkDir $ pathJoin [ paths.top, paths.sub ]
  for_ categories \c ->
    orMkDir $ pathJoin [ paths.top, paths.sub, pathName c ]
  for_ gs \g -> do
    let
      myls = map fromLedger g.ledgers
    out <- effEither $ printCSVWithOrder ledgerOrder myls
    S.writeTextFile
      UTF8
      (pathJoin [ paths.top, paths.sub, pathName (cat g.account), pathName g.account <> ".csv" ])
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
  }
paths =
  { top: "dist"
  , sub: "ledger"
  }
