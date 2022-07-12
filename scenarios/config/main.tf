# This will create a AWS Config setup with a few reasonable basics
# There are a lot potential configuration options, so please consult the module documentation if in doubt

module "config" {
  source = "git::https://github.com/moritzheiber/terraform-aws-core-modules.git//config"
}
