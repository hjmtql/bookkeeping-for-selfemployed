module Business.Bookkeeping.Data.Date where

import Prelude
import Business.Bookkeeping.Type (Month, Year, Day)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.String (joinWith)
import Record.CSV.Printer.ToCSV (class ToCSV)

-- 取引日
data Date
  = Date Year Month Day

derive instance eqDate :: Eq Date

derive instance ordDate :: Ord Date

derive instance genericDate :: Generic Date _

instance showDate :: Show Date where
  show = genericShow

instance toCSVDate :: ToCSV Date where
  toCSV (Date y m d) = joinWith "/" $ map show [ y, m, d ]
