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
