# Bookkeeping for self-employed

[![Build Status](https://travis-ci.org/hjmtql/bookkeeping-for-selfemployed.svg?branch=master)](https://travis-ci.org/hjmtql/bookkeeping-for-selfemployed)

Write troublesome double-entry bookkeeping programmatically!

This library is strongly inspired by [Haskell bookkeeping-jp Sample](https://github.com/arowM/haskell-bookkeeping-jp-sample)

## Feature

- Automatic serial number in date order
- 1to1 and 1toN compound entry
- Journal and general ledger csv output
- Trial balance and its monthly csv output

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
transaction = do
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
├── 2019
.   ...
└── 2020
    ├── journal.csv
    ├── ledger
    │   ├── Assets
    │   │   └── WithdrawalsByOwner.csv
    │   ├── Expenses
    │   │   ├── Commission.csv
    │   │   ├── Communication.csv
    │   │   ├── Rent.csv
    │   │   ├── Supplies.csv
    │   │   ├── Travel.csv
    │   │   └── Utilities.csv
    │   ├── Liabilities
    │   │   └── AccountsPayable.csv
    │   ├── Revenue
    │   │   └── Sales.csv
    │   └── Stock
    └── summary
        ├── monthly
        │   ├── 1
        │   │   ├── trialBalance.csv
        │   │   └── trialBalanceSummary.csv
        .   .   ...
        │   ├── 2
        │   │   ├── trialBalance.csv
        │   │   └── trialBalanceSummary.csv
        │   └── 12
        │       ├── trialBalance.csv
        │       └── trialBalanceSummary.csv
        ├── trialBalance.csv
        └── trialBalanceSummary.csv
```

The contents like below

dist/2020/journal.csv
```
No,日付,摘要,借方勘定科目,貸方勘定科目,金額
2,2020/1/25,"家賃按分5割1月分",地代家賃,事業主貸,25000
3,2020/2/15,"名刺作成",消耗品費,事業主貸,5000
3,2020/2/15,"名刺作成",支払手数料,事業主貸,200
4,2020/2/18,"PC買掛",消耗品費,事業主貸,100000
4,2020/2/18,"PC買掛",消耗品費,買掛金,50000
5,2020/2/20,"xxxコーディング",事業主貸,売上,100000
6,2020/2/25,"家賃按分5割2月分",地代家賃,事業主貸,25000
7,2020/3/10,"yyyサーバー構築",事業主貸,売上,200000
8,2020/3/25,"家賃按分5割3月分",地代家賃,事業主貸,25000
9,2020/3/30,"PC買掛完了",買掛金,事業主貸,50000
```

dist/2020/ledger/Revenue/Sales.csv
```
No,日付,摘要,勘定科目,借方金額,貸方金額
5,2020/2/20,"xxxコーディング",事業主貸,,100000
7,2020/3/10,"yyyサーバー構築",事業主貸,,200000
```

dist/2020/ledger/Assets/WithdrawalsByOwner.csv
```
No,日付,摘要,勘定科目,借方金額,貸方金額
2,2020/1/25,"家賃按分5割1月分",地代家賃,,25000
3,2020/2/15,"名刺作成",消耗品費,,5000
3,2020/2/15,"名刺作成",支払手数料,,200
4,2020/2/18,"PC買掛",消耗品費,,100000
5,2020/2/20,"xxxコーディング",売上,100000,
6,2020/2/25,"家賃按分5割2月分",地代家賃,,25000
7,2020/3/10,"yyyサーバー構築",売上,200000,
8,2020/3/25,"家賃按分5割3月分",地代家賃,,25000
9,2020/3/30,"PC買掛完了",買掛金,,50000
```

dist/2020/summary/trialBalance.csv
```
勘定科目,借方合計,貸方合計,借方残高,貸方残高
事業主貸,300000,230200,69800,
売上,,300000,,300000
買掛金,50000,50000,,
地代家賃,75000,,75000,
通信費,,,,
水道光熱費,,,,
交通費,,,,
消耗品費,155000,,155000,
支払手数料,200,,200,
```

dist/2020/summary/trialBalanceSummary.csv
```
勘定科目分類,借方合計,貸方合計,借方残高,貸方残高
資産,300000,230200,69800,
負債,50000,50000,,
資本,,,,
収益,,300000,,300000
費用,230200,,230200,
```
