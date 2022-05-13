let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.0-20220510/packages.dhall
        sha256:0b0d4db1f2f0acd3b37fa53220644ac6f64cf9b5d0226fd097c0593df563d5be

let overrides = {=}

let additions =
      { record-csv =
        { dependencies =
          [ "free", "numbers", "parsing", "record", "typelevel-prelude" ]
        , repo = "https://github.com/hjmtql/purescript-record-csv"
        , version = "v0.3.0"
        }
      , generics-enum-helper =
        { dependencies = [] : List Text
        , repo = "https://github.com/hjmtql/purescript-generics-enum-helper.git"
        , version = "v1.2.0"
        }
      }

in  upstream // overrides // additions
