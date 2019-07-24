# This will create two groups, "admins" and "users" and let them assume the roles "resource-admin" or "resource-user" in the _same_ account, but with multi-factor authentication
#
# For more options you can set here please refer to the module documentation: https://github.com/moritzheiber/terraform-aws-core-modules

module "iam_users" {
  source = "git::https://github.com/moritzheiber/terraform-aws-core-modules.git//iam-users?ref=v0.3.5"

  # This includes some random bits here purely for demonstrational purposes. Please use a distinct unique identifier otherwise!
  iam_account_alias = "my-aws-account-${substr(sha256(file("iam_one_account.tf")), 0, 20)}"
}

module "iam_resources" {
  source = "git::https://github.com/moritzheiber/terraform-aws-core-modules.git//iam-resources?ref=v0.3.5"

  # Mandatory parameter so we can't skip it
  iam_account_alias = "my-aws-account"
  # This will make sure we're only setting the IAM account alias once, as we're operating in the same account
  set_iam_account_alias = false
}
