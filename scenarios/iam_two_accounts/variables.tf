# This only works with setting up two CLI/SharedCredentials profiles, one of the first account ("users") and one for the second account ("resources") because otherwise you won't be able to pass two sets of credentials at the same time. That's why the provider definitions have a mandatory "profile" variable attached to them

variable "iam_profile_users" {
  type        = string
  description = "The AWS CLI/SharedCredentials profile to provision the IAM users account with"
}

variable "iam_profile_resources" {
  type        = string
  description = "The AWS CLI/SharedCredentials profile to provision the IAM resources account with"
}

variable "users_account_id" {
  type        = string
  description = "The AWS account ID for the account your users are supposed to live in"
}
variable "resources_account_id" {
  type        = string
  description = "The AWS account ID for the account your resources are supposed to live in"
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
