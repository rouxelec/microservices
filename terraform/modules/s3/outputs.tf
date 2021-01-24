output "s3_bucket_release_name" {
  description = "Bucket name"
  value       = aws_s3_bucket.releases.id
}

output "s3_bucket_config_name" {
  description = "Bucket config name"
  value       = aws_s3_bucket.config.id
}