module Business.Bookkeeping.CategorySummary
  ( CategorySummary
  , mkCategorySummary
  ) where

import Prelude hiding (class Category)
import Business.Bookkeeping.Class.Account (class Account, cat)
import Business.Bookkeeping.Class.Category (class AccountCategory, categories)
import Business.Bookkeeping.Data.Summary (SummaryR, mkSummary)
import Business.Bookkeeping.GeneralLedger (GeneralLedger)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Bounded (class GenericBottom)
import Data.Generic.Rep.Enum (class GenericEnum)
import Data.List (List, concatMap, filter)
import Data.Symbol (SProxy(..))
import Record (insert)

-- 勘定科目の分類別の合計金額
type CategorySummary c
  = SummaryR ( category :: c )

mkCategorySummary ::
  forall c a rep.
  AccountCategory c =>
  Account c a =>
  Generic c rep =>
  GenericBottom rep =>
  GenericEnum rep =>
  List (GeneralLedger a) -> List (CategorySummary c)
mkCategorySummary gls =
  categories
    <#> ( \c ->
          { category: c
          , ledgers:
              concatMap _.ledgers
                $ filter (\gl -> cat gl.account == c) gls
          }
      )
    <#> ( \l ->
          insert (SProxy :: SProxy "category") l.category
            $ mkSummary l.ledgers
      )
