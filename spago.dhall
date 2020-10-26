{ name = "bcrypt"
, dependencies = [ "aff", "effect", "psci-support" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
, license = "MIT"
, repository = "git://github.com/VFabricio/purescript-bcrypt.git"
}
