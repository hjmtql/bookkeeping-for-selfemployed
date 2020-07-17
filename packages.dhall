let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.13.8-20200716/packages.dhall sha256:c4683b4c4da0fd33e0df86fc24af035c059270dd245f68b79a7937098f6c6542

let overrides = {=}

let additions =
      { record-csv =
        { dependencies =
          [ "free", "numbers", "parsing", "record", "typelevel-prelude" ]
        , repo = "https://github.com/hjmtql/purescript-record-csv"
        , version = "v0.1.1"
        }
      }

in  upstream // overrides // additions
