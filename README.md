# Bookkeeping for self-employed

[![Build Status](https://travis-ci.org/hjmtql/bookkeeping-for-selfemployed.svg?branch=master)](https://travis-ci.org/hjmtql/bookkeeping-for-selfemployed)

Write troublesome double-entry bookkeeping programmatically!

This library is strongly inspired by [Haskell bookkeeping-jp Sample](https://github.com/arowM/haskell-bookkeeping-jp-sample)

## Feature

- Automatic serial number in date order
- 1to1 and 1toN compound entry
- Journal and general ledger csv output

## Usage

See the [test](test)

You can generate csv outputs by running the following command

```sh
yarn
yarn test
```

See the [outputs](https://github.com/hjmtql/bookkeeping-for-selfemployed/tree/gh-pages) on github pages.

## Overview

Write transactions like this...

```purescript
transaction =
  year 2020
    month 1 do
      day 10 do
        sales "some work A" 50_000
        travel "round trip P" 10_000
      day 20 do
        sales "some work B" 100_000
    month 2 do
    ...
```

Then you will get csv files

```
dist
├── journal.csv
└── ledger
    ├── Assets
    │   └── WithdrawalsByOwner.csv
    ├── Expenses
    │   ├── Commission.csv
    │   ├── Communication.csv
    │   ├── Rent.csv
    │   ├── Supplies.csv
    │   ├── Travel.csv
    │   └── Utilities.csv
    ├── Liabilities
    │   └── InvestmentsByOwner.csv
    ├── Revenue
    │   └── Sales.csv
    └── Stock
```

Contents like below

dist/journal.csv
```
No,日付,摘要,借方勘定科目,貸方勘定科目,金額
1,2020/1/25,"家賃按分5割1月分",地代家賃,事業主借,25000
2,2020/2/15,"名刺作成",消耗品費,事業主借,5000
2,2020/2/15,"名刺作成",支払手数料,事業主借,200
3,2020/2/20,"xxxコーディング",事業主貸,売上,100000
4,2020/2/25,"家賃按分5割2月分",地代家賃,事業主借,25000
5,2020/3/10,"yyyサーバー構築",事業主貸,売上,200000
6,2020/3/25,"家賃按分5割3月分",地代家賃,事業主借,25000
```

dist/ledger/Revenue/Sales.csv
```
No,日付,摘要,勘定科目,借方金額,貸方金額
3,2020/2/20,"xxxコーディング",事業主貸,,100000
5,2020/3/10,"yyyサーバー構築",事業主貸,,200000
```

dist/ledger/Assets/WithdrawalsByOwner.csv
```
No,日付,摘要,勘定科目,借方金額,貸方金額
3,2020/2/20,"xxxコーディング",売上,100000,
5,2020/3/10,"yyyサーバー構築",売上,200000,
```
