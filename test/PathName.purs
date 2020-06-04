module Test.PathName where

import Business.Bookkeeping.Data.Category (Category)
import Data.Generic.Rep.Show (genericShow)
import Test.MyAccount (MyAccount)

class PathName a where
  pathName :: a -> String

instance pathNameMyAccount :: PathName MyAccount where
  pathName = genericShow

instance pathNameCategory :: PathName Category where
  pathName = genericShow
