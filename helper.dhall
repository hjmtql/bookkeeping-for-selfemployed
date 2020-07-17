let conf = ./spago.dhall

in conf // {
  sources = conf.sources # [ "helper/**/*.purs" ],
  dependencies = conf.dependencies # [ "node-fs", "record-csv" ]
}
