let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.10-20230824/packages.dhall
        sha256:9950996d73eee0e7ad15e00d28e04bc97a1fb2fda2012c3a60953e23558e1c5f

let overrides = {=}

let additions =
      { record-csv =
        { dependencies = [ "string-parsers", "typelevel-prelude" ]
        , repo = "https://github.com/hjmtql/purescript-record-csv"
        , version = "v0.3.2"
        }
      , generics-enum-helper =
        { dependencies = [] : List Text
        , repo = "https://github.com/hjmtql/purescript-generics-enum-helper.git"
        , version = "v1.2.1"
        }
      }

in  upstream // overrides // additions
