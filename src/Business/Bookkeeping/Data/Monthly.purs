module Business.Bookkeeping.Data.Monthly
  ( Monthly
  , monthes
  ) where

import Data.Date (Month(..))
import Data.Enum (enumFromTo)
import Data.List (List)

type Monthly a
  = { month :: Month
    , balances :: List a
    }

monthes :: List Month
monthes = enumFromTo January December
