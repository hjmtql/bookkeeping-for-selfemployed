module Business.Bookkeeping.Yearly.Journal
  ( YearlyJournal
  , mkYearlyJournals
  ) where

import Prelude
import Business.Bookkeeping.Data.Yearly (Yearly, mkYears)
import Business.Bookkeeping.Journal (Journal)
import Data.Date (year)
import Data.List (List, filter)

type YearlyJournal a
  = Yearly (Journal a)

mkYearlyJournals :: forall a. List (Journal a) -> List (YearlyJournal a)
mkYearlyJournals js =
  years
    <#> \y ->
        { year: y
        , contents: filter (\j -> year j.date == y) js
        }
  where
  years = mkYears js
