output "s3_bucket_release_name" {
  description = "Bucket name"
  value       = aws_s3_bucket.releases.id
}