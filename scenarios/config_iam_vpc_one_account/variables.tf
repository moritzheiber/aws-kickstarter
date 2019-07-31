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

variable "set_iam_account_alias" {
  type        = bool
  description = "Whether or not you want to set the account IAM alias"
  default     = false
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
