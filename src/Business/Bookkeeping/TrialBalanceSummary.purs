module Business.Bookkeeping.TrialBalanceSummary
  ( TrialBalanceSummary
  , mkTrialBalanceSummary
  ) where

import Prelude hiding (class Category)
import Business.Bookkeeping.Class.Account (class Account, cat)
import Business.Bookkeeping.Class.Category (class AccountCategory, categories)
import Business.Bookkeeping.Data.Summary (TrialBalanceR, plus)
import Business.Bookkeeping.TrialBalance (TrialBalance)
import Data.Foldable (foldr)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Bounded (class GenericBottom)
import Data.Generic.Rep.Enum (class GenericEnum)
import Data.List (List, filter)
import Data.Maybe (Maybe(..))
import Data.Symbol (SProxy(..))
import Record (delete, insert)

-- 勘定科目分類別の合計残高試算表（BSとPL）
type TrialBalanceSummary c
  = TrialBalanceR ( category :: c )

mkTrialBalanceSummary ::
  forall c a rep.
  AccountCategory c =>
  Account c a =>
  Generic c rep =>
  GenericBottom rep =>
  GenericEnum rep =>
  List (TrialBalance a) -> List (TrialBalanceSummary c)
mkTrialBalanceSummary tbs =
  categories
    <#> ( \c ->
          filter (\tb -> cat tb.account == c) tbs
            <#> delete (SProxy :: SProxy "account")
            # foldr foldTrialBalance initialTrialBalance
            # insert (SProxy :: SProxy "category") c
      )
  where
  foldTrialBalance x y =
    { debitTotal: plus x.debitTotal y.debitTotal
    , creditTotal: plus x.creditTotal y.creditTotal
    , debitBalance: plus x.debitBalance y.debitBalance
    , creditBalance: plus x.creditBalance y.creditBalance
    }

  initialTrialBalance =
    { debitTotal: Nothing
    , creditTotal: Nothing
    , debitBalance: Nothing
    , creditBalance: Nothing
    }
