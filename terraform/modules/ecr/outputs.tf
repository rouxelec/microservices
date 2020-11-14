output "ecr_base_img_repo_url" {
  description = "ecr repository_url"
  value       = aws_ecr_repository.baseimg.repository_url
}

output "ecr_app_repo_url" {
  description = "ecr repository_url"
  value       = aws_ecr_repository.app.repository_url
}