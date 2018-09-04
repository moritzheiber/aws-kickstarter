provider "aws" {
  region  = "eu-west-1"
  version = "~> 1.34"
}

data "aws_availability_zones" "available" {}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

variable "vpc_cidr_range" {
  type    = "string"
  default = "10.0.0.0/8"
}

variable "public_subnet_cidrs" {
  type = "list"

  default = [
    "10.0.0.0/22",
    "10.0.4.0/22",
    "10.0.8.0/22",
  ]
}

variable "private_subnet_cidrs" {
  type = "list"

  default = [
    "10.0.128.0/22",
    "10.0.132.0/22",
    "10.0.136.0/22",
  ]
}

# You can change this to any string you desire
# It will receive the account ID as its suffix as to stay unique
# This is for the template only, you should probably change
# this behaviour for your own accounts
variable "iam_account_alias" {
  type    = "string"
  default = "account"
}
