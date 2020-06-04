module Test.MyDate where

import Prelude
import Data.Date (Date, Day, Month, Year, day, month, year)
import Data.Enum (fromEnum)
import Data.String (joinWith)
import Record.CSV.Printer.ToCSV (class ToCSV)

data MyDate
  = MyDate Year Month Day

-- CSV出力時の日付フォーマット
instance toCSVMyDate :: ToCSV MyDate where
  toCSV (MyDate y m d) = joinWith "/" $ map show [ fromEnum y, fromEnum m, fromEnum d ]

fromDate :: Date -> MyDate
fromDate d = MyDate (year d) (month d) (day d)
