module Business.Bookkeeping.Helper.PathName where

class PathName a where
  pathName :: a -> String
