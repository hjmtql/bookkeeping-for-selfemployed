module Business.Bookkeeping.Helper.PathName where

import Business.Bookkeeping.Data.Category (Category)
import Data.Generic.Rep.Show (genericShow)

class PathName a where
  pathName :: a -> String

instance pathNameCategory :: PathName Category where
  pathName = genericShow
