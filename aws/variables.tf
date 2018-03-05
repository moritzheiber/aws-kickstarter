provider "aws" {
  region  = "eu-west-1"
  version = "~> 1.10"
}

data "aws_availability_zones" "available" {}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# You can change this to any string you desire
# It will receive the account ID as its suffix as to stay unique
# This is for the template only, you should probably change
# this behaviour for your own accounts
variable "iam_account_alias" {
  type    = "string"
  default = "account"
}
