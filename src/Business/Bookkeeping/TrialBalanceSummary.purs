module Business.Bookkeeping.TrialBalanceSummary
  ( TrialBalanceSummary
  , mkTrialBalanceSummary
  ) where

import Prelude hiding (class Category)
import Business.Bookkeeping.Class.Account (class Account, cat)
import Business.Bookkeeping.Class.Category (class AccountCategory, categories)
import Business.Bookkeeping.Data.Summary (TrialBalanceR, mkTrialBalanceR)
import Business.Bookkeeping.GeneralLedger (GeneralLedger)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Bounded (class GenericBottom, class GenericTop)
import Data.Generic.Rep.Enum (class GenericBoundedEnum)
import Data.List (List, concatMap, filter)
import Data.Symbol (SProxy(..))
import Record (insert)

-- 勘定科目分類別の合計残高試算表（BSとPL）
type TrialBalanceSummary c
  = TrialBalanceR ( category :: c )

mkTrialBalanceSummary ::
  forall c a rep.
  AccountCategory c =>
  Account c a =>
  Generic c rep =>
  GenericTop rep =>
  GenericBottom rep =>
  GenericBoundedEnum rep =>
  List (GeneralLedger a) -> List (TrialBalanceSummary c)
mkTrialBalanceSummary gls =
  categories
    <#> \c ->
        filter (\gl -> cat gl.account == c) gls
          # concatMap _.ledgers
          # mkTrialBalanceR
          # insert (SProxy :: SProxy "category") c
