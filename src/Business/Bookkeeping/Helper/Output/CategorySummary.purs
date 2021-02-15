module Business.Bookkeeping.Helper.Output.CategorySummary where

import Data.List
import Business.Bookkeeping.CategorySummary (CategorySummary)
import Data.Either (Either)
import Record.CSV.Error (CSVError)

class CategorySummaryOutput c where
  printCategorySummary :: List (CategorySummary c) -> Either CSVError String
