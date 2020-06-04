module Business.Bookkeeping.Data.Date where

import Prelude
import Business.Bookkeeping.Type (Month, Year, Day)
import Data.String (joinWith)

-- 取引日
data Date
  = Date Year Month Day

derive instance eqDate :: Eq Date

derive instance ordDate :: Ord Date

instance showDate :: Show Date where
  show (Date y m d) = joinWith "/" $ map show [ y, m, d ]
