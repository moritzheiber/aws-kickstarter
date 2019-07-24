# This only works with setting up two CLI/SharedCredentials profiles, one of the first account ("users") and one for the second account ("resources") because otherwise you won't be able to pass two sets of credentials at the same time. That's why the provider definitions have a mandatory "profile" variable attached to them

variable "iam_profile_users" {
  type        = string
  description = "The AWS CLI/SharedCredentials profile to provision the IAM users account with"
}

variable "iam_profile_resources" {
  type        = string
  description = "The AWS CLI/SharedCredentials profile to provision the IAM resources account with"
}

variable "users_account_id" {}
variable "resources_account_id" {}
