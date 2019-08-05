variable "bucket_prefix" {
  type        = string
  description = "The prefix attached to the AWS Config S3 bucket where evaluation results are stored"
  # The module default is "aws-config" so you don't necessarily need to specify this
  default = "my-aws-config-bucket"
}

variable "enable_lifecycle_management_for_s3" {
  type        = bool
  description = "Whether or not to enable lifecycle management for the created S3 buckets"
  # You should set this to true, or just delete the line (the default is "true"), if you're moving this into a production context
  default = false
}

variable "tags" {
  type        = map(string)
  description = "A common map of tags for all VPC resources that are created (for e.g. billing purposes)"
  default = {
    Resource = "my_cost_center"
  }
}
# This only works with setting up two CLI/SharedCredentials profiles, one of the first account ("users") and one for the second account ("resources") because otherwise you won't be able to pass two sets of credentials at the same time. That's why the provider definitions have a mandatory "profile" variable attached to them

variable "users_profile" {
  type        = string
  description = "The AWS CLI/SharedCredentials profile to provision the IAM users account with"
}

variable "resources_profile" {
  type        = string
  description = "The AWS CLI/SharedCredentials profile to provision the IAM resources account with"
}

variable "users_account_id" {
  type        = string
  description = "The AWS account ID for the account the users are going to live in"
}
variable "resources_account_id" {
  type        = string
  description = "The AWS account ID for the account the resources are going to live in"
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
