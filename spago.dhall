{ name = "bookkeeping"
, dependencies =
  [ "datetime", "generics-rep", "record", "strings", "transformers" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
