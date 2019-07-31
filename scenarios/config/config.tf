# This will create a AWS Config setup with a few reasonable basics
# There are a lot potential configuration options, so please consult the module documentation if in doubt
#
# The provider configuration happens inside the module. If you wish to customize it (i.e. change the version etc) you have to pass the provider in a "providers" hash to the module directly

module "config" {
  source = "git::https://github.com/moritzheiber/terraform-aws-core-modules.git//config?ref=v0.3.8"

  bucket_prefix                      = var.bucket_prefix
  enable_lifecycle_management_for_s3 = var.enable_lifecycle_management_for_s3
}
