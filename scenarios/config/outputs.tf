output "config_s3_bucket_arn" {
  description = "The ARN of the S3 bucket AWS Config writes its findings to"
  value       = module.config.config_s3_bucket_arn
}
