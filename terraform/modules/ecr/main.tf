resource "aws_ecr_repository" "app" {
  name                 = replace("${var.app_name}-${var.namespace}-${var.project_name}","_","-")
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository" "appv2" {
  name                 = replace("${var.app_name}v2-${var.namespace}-${var.project_name}","_","-")
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}


resource "aws_ecr_repository" "baseimg" {
  name                 = replace("${var.base_img_name}-${var.namespace}-${var.project_name}","_","-")
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ssm_parameter" "ecr_img_repo_url" {
  name  = "ecr_img_repo_url"
  type  = "String"
  value = aws_ecr_repository.baseimg.repository_url
}

resource "aws_ssm_parameter" "ecr_app_repo_url" {
  name  = "ecr_app_repo_url"
  type  = "String"
  value = aws_ecr_repository.app.repository_url
}

resource "aws_ssm_parameter" "ecr_appv2_repo_url" {
  name  = "ecr_appv2_repo_url"
  type  = "String"
  value = aws_ecr_repository.appv2.repository_url
}