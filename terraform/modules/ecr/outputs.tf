output "ecr_base_img_repo_url" {
  description = "ecr repository_url"
  value       = aws_ecr_repository.baseimg.repository_url
}

output "ecr_app_repo_url" {
  description = "ecr repository_url"
  value       = aws_ecr_repository.app.repository_url
}

output "ecr_app_repo_name" {
  description = "ecr repository_name"
  value       = aws_ecr_repository.app.name
}

output "ecr_appv2_repo_url" {
  description = "ecr repository_url v2"
  value       = aws_ecr_repository.appv2.repository_url
}

output "ecr_appv2_repo_name" {
  description = "ecr repository_name v2"
  value       = aws_ecr_repository.appv2.name
}

output "ecr_img_repo_name" {
  description = "ecr baseimg repository_name"
  value       = aws_ecr_repository.baseimg.name
}

output "ecr_img_repo_url" {
  description = "ecr baseimg repository_url"
  value       = aws_ecr_repository.baseimg.repository_url
}