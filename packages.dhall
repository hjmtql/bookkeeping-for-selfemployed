let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.4-20220822/packages.dhall
        sha256:908b4ffbfba37a0a4edf806513a555d0dbcdd0cde7abd621f8d018d2e8ecf828

let overrides = {=}

let additions =
      { record-csv =
        { dependencies =
          [ "string-parsers", "typelevel-prelude" ]
        , repo = "https://github.com/hjmtql/purescript-record-csv"
        , version = "v0.3.1"
        }
      , generics-enum-helper =
        { dependencies = [] : List Text
        , repo = "https://github.com/hjmtql/purescript-generics-enum-helper.git"
        , version = "v1.2.0"
        }
      }

in  upstream // overrides // additions
