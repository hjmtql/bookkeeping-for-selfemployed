{ name = "bookkeeping"
, dependencies =
  [ "datetime"
  , "generics-enum-helper"
  , "generics-rep"
  , "node-fs"
  , "record"
  , "record-csv"
  , "strings"
  , "transformers"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
