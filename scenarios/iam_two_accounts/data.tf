data "aws_caller_identity" "users" {
  provider = aws.users
}

data "aws_caller_identity" "resources" {
  provider = aws.resources
}
