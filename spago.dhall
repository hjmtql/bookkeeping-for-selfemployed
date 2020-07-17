{ name = "bookkeeping"
, dependencies =
  [ "datetime"
  , "generics-rep"
  , "record"
  , "strings"
  , "sumtype-helper"
  , "transformers"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
