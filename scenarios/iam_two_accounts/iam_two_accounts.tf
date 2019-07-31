provider "aws" {
  alias = "iam_users"

  profile = var.iam_profile_users
}

provider "aws" {
  alias = "iam_resources"

  profile = var.iam_profile_resources
}

module "iam_users" {
  source = "git::https://github.com/moritzheiber/terraform-aws-core-modules.git//iam-users?ref=v0.3.8"
  providers = {
    aws = aws.iam_users
  }

  # This includes some random bits here purely for demonstrational purposes. Please use a distinct unique identifier otherwise!
  iam_account_alias    = "my-aws-account-users-${substr(sha256(file("variables.tf")), 0, 20)}"
  resources_account_id = var.resources_account_id
}

module "iam_resources" {
  source = "git::https://github.com/moritzheiber/terraform-aws-core-modules.git//iam-resources?ref=v0.3.8"
  providers = {
    aws = aws.iam_resources
  }

  # This includes some random bits here purely for demonstrational purposes. Please use a distinct unique identifier otherwise!
  iam_account_alias = "my-aws-account-resources-${substr(sha256(file("variables.tf")), 0, 20)}"
  users_account_id  = var.users_account_id
}
