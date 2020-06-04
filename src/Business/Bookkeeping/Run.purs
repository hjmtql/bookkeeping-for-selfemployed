module Business.Bookkeeping.Run
  ( generateJournal
  , generateLedger
  ) where

import Prelude
import Business.Bookkeeping.Class.Account (class Account, accounts)
import Business.Bookkeeping.GeneralLedger (GeneralLedger, mkGeneralLedger)
import Business.Bookkeeping.Journal (Journal, mkJournals)
import Business.Bookkeeping.Transaction (Transaction)
import Control.Monad.Writer (execWriter)
import Data.Either (Either)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Bounded (class GenericBottom)
import Data.Generic.Rep.Enum (class GenericEnum)
import Data.List as L

generateJournal ::
  forall a.
  Account a =>
  Transaction a Unit -> Either String (L.List (Journal a))
generateJournal = mkJournals <<< execWriter

generateLedger ::
  forall a b.
  Generic a b =>
  GenericBottom b =>
  GenericEnum b =>
  Account a =>
  L.List (Journal a) -> L.List (GeneralLedger a)
generateLedger js = flip mkGeneralLedger js <$> accounts
