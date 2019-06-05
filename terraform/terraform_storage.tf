resource "aws_s3_bucket" "terraform_backend_store" {
  # This has to be a unique name, that's why the account_id is used
  # You can give this pretty much any name you desire, as long as it is unique
  # In fact, I would suggest you do since you won't be able to use this notation
  # when working with Terraform across account boundaries
  bucket = "terraform-backend-store-${data.aws_caller_identity.current.account_id}"

  acl    = "private"
  region = data.aws_region.current.name

  tags = {
    Name        = "Resource"
    Environment = "terraform"
  }
}

