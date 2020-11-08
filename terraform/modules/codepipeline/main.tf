resource "aws_codepipeline" "project" {
  name     = "${var.app}-pipeline"
  role_arn = var.codebuild_role_arn

  artifact_store {
    location = var.releases_bucket_id
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "ECR"
      version          = "1"
      output_artifacts = ["${var.app}"]

      configuration = {
        RepositoryName                 = "${var.ecr_repo}"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["${var.app}"]
      version          = "1"

      configuration = {
        ProjectName = "${var.codebuild_project_name}"
      }
    }
  }

}