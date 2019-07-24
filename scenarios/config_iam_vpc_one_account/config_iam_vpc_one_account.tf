module "config" {
  source = "git::https://github.com/moritzheiber/terraform-aws-core-modules.git//config?ref=v0.3.6"

  bucket_prefix                      = var.bucket_prefix
  enable_lifecycle_management_for_s3 = var.enable_lifecycle_management_for_s3
}

module "core_vpc" {
  source = "git::https://github.com/moritzheiber/terraform-aws-core-modules.git//vpc?ref=v0.3.6"

  resource_tag = var.resource_tag
}

module "iam_users" {
  source = "git::https://github.com/moritzheiber/terraform-aws-core-modules.git//iam-users?ref=v0.3.6"

  # This includes some random bits here purely for demonstrational purposes. Please use a distinct unique identifier otherwise!
  iam_account_alias = "my-aws-account-${substr(sha256(file("config_iam_vpc_one_account.tf")), 0, 20)}"
}

module "iam_resources" {
  source = "git::https://github.com/moritzheiber/terraform-aws-core-modules.git//iam-resources?ref=v0.3.6"

  # Mandatory parameter so we can't skip it
  iam_account_alias = "my-aws-account"
  # This will make sure we're only setting the IAM account alias once, as we're operating in the same account
  set_iam_account_alias = var.set_iam_account_alias
}
