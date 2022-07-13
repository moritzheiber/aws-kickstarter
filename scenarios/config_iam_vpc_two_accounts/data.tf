data "aws_caller_identity" "users" {
  providers = {
    aws = aws.users
  }
}

data "aws_caller_identity" "resources" {
  providers = {
    aws = aws.resources
  }
}
