module Business.Bookkeeping.Journal
  ( Journal
  , mkJournals
  ) where

import Prelude
import Business.Bookkeeping.Data.Date (Date(..))
import Business.Bookkeeping.Data.Slip (DC(..))
import Business.Bookkeeping.Transaction (YearSlip)
import Business.Bookkeeping.Type (Money)
import Data.Functor (mapFlipped)
import Data.List as L
import Data.List.NonEmpty as NE
import Data.Symbol (SProxy(..))
import Record as Record

-- 仕訳帳
type Journal a
  = { no :: Int
    , date :: Date
    , summary :: String
    , debitAccount :: a
    , creditAccount :: a
    , amount :: Money
    }

mkJournals :: forall a. L.List (YearSlip a) -> L.List (Journal a)
mkJournals =
  build
    <<< L.sortBy (comparing _.date)
    <<< map dateMod
  where
  dateMod t =
    Record.insert (SProxy :: SProxy "date") date
      <<< Record.delete (SProxy :: SProxy "year")
      <<< Record.delete (SProxy :: SProxy "month")
      <<< Record.delete (SProxy :: SProxy "day")
      $ t
    where
    date = Date t.year t.month t.day

  build =
    L.concat
      <<< L.mapWithIndex
          ( \i r ->
              map
                ( Record.insert (SProxy :: SProxy "no") (i + 1) -- NOTE: starts with 1
                    <<< Record.insert (SProxy :: SProxy "date") r.date
                    <<< Record.insert (SProxy :: SProxy "summary") r.summary
                ) case r.content of
                Single s ->
                  L.singleton
                    { debitAccount: s.debit
                    , creditAccount: s.credit
                    , amount: s.amount
                    }
                MultipleD d ->
                  NE.toList
                    $ mapFlipped d.debits \item ->
                        { debitAccount: item.account
                        , creditAccount: d.credit
                        , amount: item.amount
                        }
                MultipleC c ->
                  NE.toList
                    $ mapFlipped c.credits \item ->
                        { debitAccount: item.account
                        , creditAccount: c.debit
                        , amount: item.amount
                        }
          )
