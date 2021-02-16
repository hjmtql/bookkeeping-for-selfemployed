module Business.Bookkeeping.Data.Monthly
  ( Monthly
  , months
  ) where

import Data.Date (Month(..))
import Data.Enum (enumFromTo)
import Data.List (List)

type Monthly a
  = { month :: Month
    , balances :: List a
    }

months :: List Month
months = enumFromTo January December
