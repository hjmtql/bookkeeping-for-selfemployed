module Business.Bookkeeping.TrialBalanceSummary
  ( TrialBalanceSummary
  , mkTrialBalanceSummary
  ) where

import Prelude hiding (class Category)
import Business.Bookkeeping.Class.Account (class Account, cat)
import Business.Bookkeeping.Class.Category (class AccountCategory, categories)
import Business.Bookkeeping.Data.Summary (TrialBalanceR, mkTrialBalanceR)
import Business.Bookkeeping.GeneralLedger (GeneralLedger)
import Data.Bounded.Generic (class GenericBottom, class GenericTop)
import Data.Enum.Generic (class GenericBoundedEnum)
import Data.Generic.Rep (class Generic)
import Data.List (List, concatMap, filter)
import Record (insert)
import Type.Proxy (Proxy(..))

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
          # insert (Proxy :: Proxy "category") c
