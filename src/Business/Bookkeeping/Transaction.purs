module Business.Bookkeeping.Transaction
  ( Transaction
  , Transaction'
  , YearSlip
  , MonthSlip
  , DaySlip
  , year
  , month
  , day
  , single
  , multipleD
  , multipleC
  , item
  ) where

import Prelude
import Business.Bookkeeping.Data.Slip (MultipleC, MultipleD, Single, Slip, SlipRow, mkSlip, mkSlipC, mkSlipD)
import Business.Bookkeeping.Type (Month, Year, Day)
import Control.Monad.Writer (Writer, mapWriter, tell)
import Data.Bifunctor (rmap)
import Data.List as L
import Data.List.NonEmpty as NE
import Data.Symbol (class IsSymbol, SProxy(..))
import Prim.Row as R
import Record as Record

-- 取引記録用DSL
type Transaction acc
  = Transaction' (YearSlip acc)

type Transaction' accElem
  = Writer (L.List accElem)

type YearSlip a
  = { year :: Year
    , month :: Month
    , day :: Day
    | SlipRow a
    }

type MonthSlip a
  = { month :: Month
    , day :: Day
    | SlipRow a
    }

type DaySlip a
  = { day :: Day
    | SlipRow a
    }

year :: forall a. Year -> Transaction' (MonthSlip a) Unit -> Transaction' (YearSlip a) Unit
year = mapInsert (SProxy :: SProxy "year")

month :: forall a. Month -> Transaction' (DaySlip a) Unit -> Transaction' (MonthSlip a) Unit
month = mapInsert (SProxy :: SProxy "month")

day :: forall a. Day -> Transaction' (Slip a) Unit -> Transaction' (DaySlip a) Unit
day = mapInsert (SProxy :: SProxy "day")

mapInsert ::
  forall a b k v.
  IsSymbol k =>
  R.Lacks k a =>
  R.Cons k v a b =>
  SProxy k -> v -> Transaction' { | a } Unit -> Transaction' { | b } Unit
mapInsert k v = mapWriter (rmap (map (Record.insert k v)))

single :: forall a. Single a -> Transaction' (Slip a) Unit
single = tr <<< mkSlip

multipleD :: forall a. MultipleD a -> Transaction' (Slip a) Unit
multipleD = tr <<< mkSlipD

multipleC :: forall a. MultipleC a -> Transaction' (Slip a) Unit
multipleC = tr <<< mkSlipC

tr :: forall a. Slip a -> Transaction' (Slip a) Unit
tr = tell <<< L.singleton

item :: forall a. a -> NE.NonEmptyList a
item = NE.singleton
