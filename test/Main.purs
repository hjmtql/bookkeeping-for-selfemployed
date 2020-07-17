module Test.Main where

import Prelude
import Business.Bookkeeping.Helper.Output (effEither, outputJournal, outputLedger)
import Business.Bookkeeping.Run (generateJournal, generateLedger)
import Business.Bookkeeping.Transaction (Transaction, day, item, month, multipleD, single, year)
import Effect (Effect)
import Test.MyAccount (MyAccount(..))

-- 取引の記録
transaction :: Transaction MyAccount Unit
transaction =
  year 2020 do
    rent
    month 2 do
      day 15 do
        -- 複数借方の取引（1toNの複合仕訳）
        multipleD
          { summary: "名刺作成"
          , debits:
              item { account: Supplies, amount: 5_000 }
                <> item { account: Commission, amount: 200 }
          , credit: InvestmentsByOwner
          }
      day 20 do
        sales "xxxコーディング" 100_000
    month 3 do
      day 10 do
        sales "yyyサーバー構築" 200_000
  where
  -- 売上
  sales s a =
    single
      { summary: s
      , debit: WithdrawalsByOwner
      , credit: Sales
      , amount: a
      }

  -- 家賃（定常的な経費）
  rent = do
    month 1 $ day 25 $ _家賃按分5割 "1月分" 25_000
    month 2 $ day 25 $ _家賃按分5割 "2月分" 25_000
    month 3 $ day 25 $ _家賃按分5割 "3月分" 25_000
    where
    _家賃按分5割 when amount =
      single
        { summary: "家賃按分5割" <> when
        , debit: Rent
        , credit: InvestmentsByOwner
        , amount: amount
        }

-- 仕訳帳と総勘定元帳のCSV出力
main :: Effect Unit
main = do
  js <- effEither $ generateJournal transaction
  let
    ls = generateLedger js
  outputJournal js
  outputLedger ls
