# This will create two groups, "admins" and "users" and let them assume the roles "resource-admin" or "resource-user" in the _same_ account, but with multi-factor authentication
#
# For more options you can set here please refer to the module documentation: https://github.com/moritzheiber/terraform-aws-core-modules

module "iam_users" {
  source = "git::https://github.com/moritzheiber/terraform-aws-core-modules.git//iam-users?ref=v0.3.8"

  # This includes some random bits here purely for demonstrational purposes. Please use a distinct unique identifier otherwise!
  iam_account_alias = "my-aws-account-${substr(sha256(file("iam_one_account.tf")), 0, 20)}"
}

module "iam_resources" {
  source = "git::https://github.com/moritzheiber/terraform-aws-core-modules.git//iam-resources?ref=v0.3.8"

  # Mandatory parameter so we can't skip it
  iam_account_alias = "my-aws-account"
  # This will make sure we're only setting the IAM account alias once, as we're operating in the same account
  set_iam_account_alias = false
}


# These two users will be created as a part of this initial example
# You can add as many users as you want, but be weiry of using lists or maps
# as their index will remove users once you have to offboard a team member
# This will probably remain the same until Terraform supports for_each for resources
# Reference: https://github.com/hashicorp/terraform/issues/17179
variable "admin_name" {
  type        = string
  description = "The name of the administrator this module adds to the IAM definitions"
  default     = "admin"
}

variable "user_name" {
  type        = string
  description = "The name of the user this module adds to the IAM definitions"
  default     = "user"
}
