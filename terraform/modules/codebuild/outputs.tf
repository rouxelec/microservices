output "project_name" {
  description = "Project name"
  value       = join("", aws_codebuild_project.default.*.name)
}

output "project_id" {
  description = "Project ID"
  value       = join("", aws_codebuild_project.default.*.id)
}

output "cache_bucket_name" {
  description = "Cache S3 bucket name"
  value       = var.enabled && local.s3_cache_enabled ? join("", aws_s3_bucket.cache_bucket.*.bucket) : "UNSET"
}

output "cache_bucket_arn" {
  description = "Cache S3 bucket ARN"
  value       = var.enabled && local.s3_cache_enabled ? join("", aws_s3_bucket.cache_bucket.*.arn) : "UNSET"
}

output "badge_url" {
  description = "The URL of the build badge when badge_enabled is enabled"
  value       = join("", aws_codebuild_project.default.*.badge_url)
}

output "project_arn" {
  description = "Project ARN"
  value       = join("", aws_codebuild_project.default.*.arn)
}