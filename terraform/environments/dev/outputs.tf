
output "role_id" {
  description = "IAM Role ID"
  value       = module.role.role_id
}

output "role_arn" {
  description = "IAM Role ARN"
  value       = module.role.role_arn
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
  value       = module.alb.lambda_target_group_arn

}

output "ec2_target_group_arn" {
  description = "ec2 tg arn"
  value       = module.alb.ec2_target_group_arn

}

output "s3_bucket_release_name" {
  description = "releases bucket"
  value       = module.s3.s3_bucket_release_name
}

output "s3_bucket_config_name" {
  description = "config bucket"
  value       = module.s3.s3_bucket_config_name
}

output "vpc_id" {
  value = module.vpc.id
}

output "ecr_app_repo_url" {
  value = module.ecr.ecr_app_repo_url
}

output "ecr_app_repo_name" {
  value = module.ecr.ecr_app_repo_name
}

output "ecr_appv2_repo_url" {
  value = module.ecr.ecr_app_repo_url
}

output "ecr_appv2_repo_name" {
  value = module.ecr.ecr_app_repo_name
}

output "aws_lambda_function_arn" {
  value = module.lambda.aws_lambda_function_arn
}

output "aws_lambda_function_name" {
  value = module.lambda.aws_lambda_function_name
}

output "aws_lambda_function_alias" {
  value = module.lambda.aws_lambda_function_alias
}