output "project_name_app" {
  description = "Project name"
  value       = module.codebuild_app.project_name
}

output "project_id" {
  description = "Project ID"
  value       = module.codebuild_app.project_id
}

output "role_id" {
  description = "IAM Role ID"
  value       = module.role.role_id
}

output "role_arn" {
  description = "IAM Role ARN"
  value       = module.role.role_arn
}

output "cache_bucket_name" {
  description = "Cache S3 bucket name"
  value       = module.codebuild_base_img.cache_bucket_name
}

output "cache_bucket_arn" {
  description = "Cache S3 bucket ARN"
  value       = module.codebuild_base_img.cache_bucket_arn
}

output "badge_url" {
  description = "The URL of the build badge when badge_enabled is enabled"
  value       = module.codebuild_base_img.badge_url
}

output "alb_name" {
  description = "Alb name"
  value       = module.alb.alb_dns
}

output "vpc_public_subnets" {
  description = "vpc public subnets"
  value       = module.vpc.public_subnet_ids
}

output "lambda_target_group_arn" {
  description = "lambda tg arn"
  value = module.alb.lambda_target_group_arn
  
}