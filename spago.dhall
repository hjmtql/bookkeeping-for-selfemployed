{ name = "bookkeeping"
, dependencies =
  [ "console"
  , "effect"
  , "generics-rep"
  , "node-fs"
  , "psci-support"
  , "record"
  , "record-csv"
  , "record-extra"
  , "transformers"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
