{ name = "bookkeeping"
, dependencies =
  [ "bifunctors"
  , "datetime"
  , "effect"
  , "either"
  , "enums"
  , "exceptions"
  , "foldable-traversable"
  , "generics-enum-helper"
  , "lists"
  , "maybe"
  , "node-buffer"
  , "node-fs"
  , "prelude"
  , "record"
  , "record-csv"
  , "strings"
  , "transformers"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
