module Business.Bookkeeping.Helper.Output.Date where

import Prelude
import Data.Date as D
import Data.Enum (fromEnum)
import Data.String (joinWith)
import Record.CSV.Printer.ToCSV (class ToCSV)

data Date
  = Date D.Year D.Month D.Day

instance toCSVDate :: ToCSV Date where
  toCSV (Date y m d) = joinWith "/" $ map show [ fromEnum y, fromEnum m, fromEnum d ]

fromDate :: D.Date -> Date
fromDate d = Date (D.year d) (D.month d) (D.day d)
