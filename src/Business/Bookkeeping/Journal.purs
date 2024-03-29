module Business.Bookkeeping.Journal
  ( Journal
  , mkJournals
  ) where

import Prelude
import Business.Bookkeeping.Data.Slip (DC(..))
import Business.Bookkeeping.Transaction (YearSlip)
import Business.Bookkeeping.Type (Money)
import Data.Date (Date, exactDate)
import Data.Either (Either(..), note)
import Data.Enum (toEnum)
import Data.Functor (mapFlipped)
import Data.FunctorWithIndex (mapWithIndex)
import Data.List as L
import Data.List.NonEmpty as NE
import Data.String (joinWith)
import Data.Traversable (traverse)
import Record as Record
import Type.Proxy (Proxy(..))

-- 仕訳帳
type Journal a
  = { no :: Int
    , date :: Date
    , summary :: String
    , debitAccount :: a
    , creditAccount :: a
    , amount :: Money
    }

mkJournals :: forall a. L.List (YearSlip a) -> Either String (L.List (Journal a))
mkJournals =
  map build
    <<< map (L.sortBy (comparing _.date))
    <<< traverse dateMod
  where
  dateMod t =
    ( case eDate of
        Right date -> Right <<< Record.insert (Proxy :: Proxy "date") date
        Left err -> \_ -> Left err
    )
      <<< Record.delete (Proxy :: Proxy "year")
      <<< Record.delete (Proxy :: Proxy "month")
      <<< Record.delete (Proxy :: Proxy "day")
      $ t
    where
    eDate =
      note ("Invalid Date " <> dateString <> ".") do
        y <- toEnum t.year
        m <- toEnum t.month
        d <- toEnum t.day
        exactDate y m d

    dateString = joinWith "/" $ map show [ t.year, t.month, t.day ]

  build =
    L.concat
      <<< mapWithIndex
          ( \i r ->
              map
                ( Record.insert (Proxy :: Proxy "no") (i + 1) -- NOTE: starts with 1
                    <<< Record.insert (Proxy :: Proxy "date") r.date
                    <<< Record.insert (Proxy :: Proxy "summary") r.summary
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
                        { debitAccount: c.debit
                        , creditAccount: item.account
                        , amount: item.amount
                        }
          )
