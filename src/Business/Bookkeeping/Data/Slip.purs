module Business.Bookkeeping.Data.Slip
  ( Slip
  , SlipRow
  , mkSlip
  , mkSlipD
  , mkSlipC
  , Single
  , SingleRow
  , MultipleD
  , MultipleDRow
  , MultipleC
  , MultipleCRow
  , Item
  , DC(..)
  ) where

import Business.Bookkeeping.Type (Money)
import Data.List.Types as LT

-- 伝票
type Slip a
  = { | SlipRow a }

type SlipRow a
  = ( summary :: String
    , content :: DC a
    )

data DC a
  = Single { | SingleRow a }
  | MultipleD { | MultipleDRow a }
  | MultipleC { | MultipleCRow a }

type Single a
  = { summary :: String
    | SingleRow a
    }

type MultipleD a
  = { summary :: String
    | MultipleDRow a
    }

type MultipleC a
  = { summary :: String
    | MultipleCRow a
    }

type SingleRow a
  = ( debit :: a
    , credit :: a
    , amount :: Money
    )

type MultipleDRow a
  = ( debits :: LT.NonEmptyList (Item a)
    , credit :: a
    )

type MultipleCRow a
  = ( debit :: a
    , credits :: LT.NonEmptyList (Item a)
    )

type Item a
  = { account :: a
    , amount :: Money
    }

mkSlip :: forall a. Single a -> Slip a
mkSlip single =
  { summary: single.summary
  , content:
      Single
        { debit: single.debit
        , credit: single.credit
        , amount: single.amount
        }
  }

mkSlipD :: forall a. MultipleD a -> Slip a
mkSlipD multiple =
  { summary: multiple.summary
  , content:
      MultipleD
        { debits: multiple.debits
        , credit: multiple.credit
        }
  }

mkSlipC :: forall a. MultipleC a -> Slip a
mkSlipC multiple =
  { summary: multiple.summary
  , content:
      MultipleC
        { debit: multiple.debit
        , credits: multiple.credits
        }
  }
