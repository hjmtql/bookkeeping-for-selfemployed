{ name = "bookkeeping"
, dependencies =
  [ "datetime"
  , "generics-enum-helper"
  , "node-fs"
  , "record"
  , "record-csv"
  , "strings"
  , "transformers"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
