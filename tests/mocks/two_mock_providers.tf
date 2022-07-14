provider "aws" {
  alias = "users"

  access_key                  = "mock_access_key" #tfsec:ignore:aws-misc-no-exposing-plaintext-credentials
  region                      = "eu-central-1"
  s3_use_path_style           = true
  secret_key                  = "mock_secret_key" #tfsec:ignore:general-secrets-sensitive-in-attribute
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ec2    = "http://localhost:4566"
    iam    = "http://localhost:4566"
    sts    = "http://localhost:4566"
    config = "http://localhost:4566"
    s3     = "http://localhost:4566"
    kms    = "http://localhost:4566"
  }
}

provider "aws" {
  alias = "resources"

  access_key                  = "mock_access_key" #tfsec:ignore:aws-misc-no-exposing-plaintext-credentials
  region                      = "eu-central-1"
  s3_use_path_style           = true
  secret_key                  = "mock_secret_key" #tfsec:ignore:general-secrets-sensitive-in-attribute
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ec2    = "http://localhost:4567"
    iam    = "http://localhost:4567"
    sts    = "http://localhost:4567"
    config = "http://localhost:4567"
    s3     = "http://localhost:4567"
    kms    = "http://localhost:4567"
  }
}
