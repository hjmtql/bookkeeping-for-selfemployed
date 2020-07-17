let conf = ./helper.dhall

in conf // {
  sources = conf.sources # [ "test/**/*.purs" ]
}
