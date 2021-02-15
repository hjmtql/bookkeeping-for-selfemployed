module Business.Bookkeeping.Data.Summary where

import Prelude
import Business.Bookkeeping.GeneralLedger (Ledger)
import Business.Bookkeeping.Type (Money)
import Data.Foldable (foldr)
import Data.List (List)
import Data.Maybe (Maybe(..))

type TrialBalanceR r
  = { debitTotal :: Maybe Money
    , creditTotal :: Maybe Money
    , debitBalance :: Maybe Money
    , creditBalance :: Maybe Money
    | r
    }

mkTrialBalanceR :: forall a. List (Ledger a) -> TrialBalanceR ()
mkTrialBalanceR ledgers = case debitTotal, creditTotal of
  Nothing, Nothing ->
    { debitTotal: Nothing
    , creditTotal: Nothing
    , debitBalance: Nothing
    , creditBalance: Nothing
    }
  Just debitAmount, Nothing ->
    { debitTotal: Just debitAmount
    , creditTotal: Nothing
    , debitBalance: Just debitAmount
    , creditBalance: Nothing
    }
  Nothing, Just creditAmount ->
    { debitTotal: Nothing
    , creditTotal: Just creditAmount
    , debitBalance: Nothing
    , creditBalance: Just creditAmount
    }
  Just debitAmount, Just creditAmount
    | debitAmount > creditAmount ->
      { debitTotal: Just debitAmount
      , creditTotal: Just creditAmount
      , debitBalance: Just $ debitAmount - creditAmount
      , creditBalance: Nothing
      }
    | debitAmount < creditAmount ->
      { debitTotal: Just debitAmount
      , creditTotal: Just creditAmount
      , debitBalance: Nothing
      , creditBalance: Just $ creditAmount - debitAmount
      }
    | otherwise ->
      { debitTotal: Just debitAmount
      , creditTotal: Just creditAmount
      , debitBalance: Nothing
      , creditBalance: Nothing
      }
  where
  debitTotal = totalF _.debitAmount

  creditTotal = totalF _.creditAmount

  totalF prop = foldr (plus <<< prop) Nothing ledgers

plus :: forall a. Semiring a => Maybe a -> Maybe a -> Maybe a
plus Nothing Nothing = Nothing

plus (Just x) Nothing = Just x

plus Nothing (Just y) = Just y

plus (Just x) (Just y) = Just (x + y)
