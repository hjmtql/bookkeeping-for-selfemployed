{ name = "bookkeeping"
, dependencies =
  [ "datetime"
  , "generics-rep"
  , "node-fs"
  , "record"
  , "record-csv"
  , "strings"
  , "sumtype-helper"
  , "transformers"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
