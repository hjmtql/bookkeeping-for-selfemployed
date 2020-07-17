module Business.Bookkeeping.Data.Category where

import Prelude
import Data.Generic.Rep (class Generic)
import Data.List as L
import Data.Sum.Helper (candidates)

-- 勘定科目の分類
data Category
  = Assets -- 資産
  | Liabilities -- 負債
  | Stock -- 資本（純資産）
  | Revenue -- 収益
  | Expenses -- 費用

derive instance eqCategory :: Eq Category

derive instance geneticCategory :: Generic Category _

categories :: L.List Category
categories = L.fromFoldable candidates
