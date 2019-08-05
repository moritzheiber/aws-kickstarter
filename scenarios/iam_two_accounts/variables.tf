# This only works with setting up two CLI/SharedCredentials profiles, one of the first account ("users") and one for the second account ("resources") because otherwise you won't be able to pass two sets of credentials at the same time. That's why the provider definitions have a mandatory "profile" variable attached to them

variable "cli_profile_users" {
  type        = string
  description = "The AWS CLI/SharedCredentials profile to provision the IAM users account with"
}

variable "cli_profile_resources" {
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

variable "iam_users" {
  type        = map(map(list(string)))
  description = "A list of users you want to create inside the \"users\" account"
  default = {
    admin = {
      groups = ["admins"]
    }
    user = {
      groups = ["users"]
    }
  }
}
