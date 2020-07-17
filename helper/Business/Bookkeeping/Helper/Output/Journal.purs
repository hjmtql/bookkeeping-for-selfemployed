module Business.Bookkeeping.Helper.Output.Journal where

import Business.Bookkeeping.Journal (Journal)
import Data.Either (Either)
import Data.List
import Record.CSV.Error (CSVError)

class JournalOutput a where
  printJournal :: List (Journal a) -> Either CSVError String
