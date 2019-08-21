output "config_s3_bucket_id" {
  description = "The ID of the S3 bucket AWS Config writes its findings to"
  value       = module.config.config_s3_bucket_id
}
