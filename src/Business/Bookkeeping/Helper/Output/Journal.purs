module Business.Bookkeeping.Helper.Output.Journal where

import Business.Bookkeeping.Journal (Journal)
import Data.List

class JournalOutput a where
  printJournal :: List (Journal a) -> String
