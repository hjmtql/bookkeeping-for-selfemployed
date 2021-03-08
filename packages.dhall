let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.14.0-20210307/packages.dhall sha256:5f9e009bf539a4d1fa2be3ea340aeca4e3ca69515f5e351473d722619906d0b0

let overrides = {=}

let additions =
      { record-csv =
        { dependencies =
          [ "free", "numbers", "parsing", "record", "typelevel-prelude" ]
        , repo = "https://github.com/hjmtql/purescript-record-csv"
        , version = "v0.2.0"
        }
      , generics-enum-helper =
        { dependencies = [] : List Text
        , repo = "https://github.com/hjmtql/purescript-generics-enum-helper.git"
        , version = "v1.1.0"
        }
      }

in  upstream // overrides // additions
