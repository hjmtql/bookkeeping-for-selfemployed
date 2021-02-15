module Business.Bookkeeping.CategorySummary
  ( CategorySummary
  , mkCategorySummary
  ) where

import Prelude hiding (class Category)
import Business.Bookkeeping.AccountSummary (AccountSummary)
import Business.Bookkeeping.Class.Account (class Account, cat)
import Business.Bookkeeping.Class.Category (class AccountCategory, categories)
import Business.Bookkeeping.Data.Summary (SummaryR)
import Data.Foldable (sum)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Bounded (class GenericBottom)
import Data.Generic.Rep.Enum (class GenericEnum)
import Data.List (List, filter)
import Data.Symbol (SProxy(..))
import Record (delete, insert)

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
  List (AccountSummary a) -> List (CategorySummary c)
mkCategorySummary ass =
  categories
    <#> ( \c ->
          filter (\as -> cat as.account == c) ass
            <#> delete (SProxy :: SProxy "account")
            # sum
            # insert (SProxy :: SProxy "category") c
      )
