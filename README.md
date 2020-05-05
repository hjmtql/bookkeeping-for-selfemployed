# Bookkeeping for self-employed

[![Build Status](https://travis-ci.org/hjmtql/bookkeeping-for-selfemployed.svg?branch=master)](https://travis-ci.org/hjmtql/bookkeeping-for-selfemployed)

Write troublesome double-entry bookkeeping programmatically!

This library is strongly inspired by [Haskell bookkeeping-jp Sample](https://github.com/arowM/haskell-bookkeeping-jp-sample)

## Feature

- Automatic serial number in date order
- 1to1 and 1toN compound entry
- Journal and general ledger csv output

## Usage

See the test

- [Main.purs](test/Main.purs)
- [MyAccount.purs](test/MyAccount.purs)

You can get csv outputs by running the following command

```sh
yarn
yarn test
```

See the outputs

- [gh-pages](https://github.com/hjmtql/bookkeeping-for-selfemployed/tree/gh-pages)

## Overview

Write transactions like this...

```purescript
transaction =
  year 2020
    month 1 do
      day 10 do
        sales "some work A" 50000
        travel "round trip P" 10000
      day 20 do
        sales "some work B" 100000
    month 2 do
    ...
```
Then you will get csv files

```
dist
├── journal.csv
└── ledger
    ├── Assets
    │   ├── Bank.csv
    │   └── Cash.csv
    ├── Expenses
    │   ├── Commission.csv
    │   ├── Communication.csv
    │   ├── Rent.csv
    │   ├── Supplies.csv
    │   ├── Travel.csv
    │   └── Utilities.csv
    ├── Liabilities
    ├── Revenue
    │   └── Sales.csv
    └── Stock
```

Contents like below

dist/journal.csv
```
amount,creditAccount,date,debitAccount,no,summary
25000,預金,2020/1/25,地代家賃,1,"家賃按分5割1月分"
5000,現金,2020/2/15,消耗品費,2,"名刺作成"
200,現金,2020/2/15,支払手数料,2,"名刺作成"
100000,売上,2020/2/20,預金,3,"xxxコーディング"
25000,預金,2020/2/25,地代家賃,4,"家賃按分5割2月分"
200000,売上,2020/3/10,預金,5,"yyyサーバー構築"
25000,預金,2020/3/25,地代家賃,6,"家賃按分5割3月分"
```

dist/ledger/Revenue/Sales.csv
```
account,creditAmount,date,debitAmount,no,summary
預金,,2020/2/20,100000,3,"xxxコーディング"
預金,,2020/3/10,200000,5,"yyyサーバー構築"
```

dist/ledger/Assets/Bank.csv
```
account,creditAmount,date,debitAmount,no,summary
地代家賃,25000,2020/1/25,,1,"家賃按分5割1月分"
売上,,2020/2/20,100000,3,"xxxコーディング"
地代家賃,25000,2020/2/25,,4,"家賃按分5割2月分"
売上,,2020/3/10,200000,5,"yyyサーバー構築"
地代家賃,25000,2020/3/25,,6,"家賃按分5割3月分"
```
