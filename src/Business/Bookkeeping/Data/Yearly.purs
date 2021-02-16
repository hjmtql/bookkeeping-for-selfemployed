module Business.Bookkeeping.Data.Yearly
  ( Yearly
  , mkYears
  ) where

import Prelude
import Data.Date (Date, Year, year)
import Data.Enum (enumFromTo)
import Data.List (List(..), head, last, singleton, sort)
import Data.Maybe (Maybe(..))

type Yearly a
  = { year :: Year
    , contents :: List a
    }

mkYears :: forall r. List { date :: Date | r } -> List Year
mkYears rs = case oldest, newest of
  Nothing, Nothing -> Nil
  Just oldestYear, Nothing -> singleton oldestYear
  Nothing, Just newestYear -> singleton newestYear
  Just oldestYear, Just newestYear -> enumFromTo oldestYear newestYear
  where
  sorted = sort $ map (\r -> year r.date) rs

  oldest = head sorted

  newest = last sorted
