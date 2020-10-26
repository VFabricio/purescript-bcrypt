{ name = "my-project"
, dependencies = [ "aff", "console", "effect", "psci-support", "strings" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
