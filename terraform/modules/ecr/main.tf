resource "aws_ecr_repository" "app" {
  name                 = var.app_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository" "baseimg" {
  name                 = var.base_img_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ssm_parameter" "ecr_app_repo_url" {
  name  = "container_name"
  type  = "String"
  value = aws_ecr_repository.app.repository_url
}