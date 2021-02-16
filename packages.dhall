let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.13.8-20210118/packages.dhall sha256:a59c5c93a68d5d066f3815a89f398bcf00e130a51cb185b2da29b20e2d8ae115

let overrides = {=}

let additions =
      { record-csv =
        { dependencies =
          [ "free", "numbers", "parsing", "record", "typelevel-prelude" ]
        , repo = "https://github.com/hjmtql/purescript-record-csv"
        , version = "v0.1.2"
        }
      , generics-enum-helper =
        { dependencies = [] : List Text
        , repo = "https://github.com/hjmtql/purescript-generics-enum-helper.git"
        , version = "v1.0.0"
        }
      }

in  upstream // overrides // additions
