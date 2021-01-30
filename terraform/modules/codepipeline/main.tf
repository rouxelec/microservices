resource "aws_codepipeline" "project" {
  name     = replace("${var.app}-${var.namespace}-${var.region}-${var.account_name}-${var.project_name}-releases", "_", "-")
  role_arn = var.codebuild_role_arn

  artifact_store {
    location = var.releases_bucket_id
    type     = "S3"
  }

  stage {
    name = "Source"



    action {
      name             = "GitHub_Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["${var.app}"]

      configuration = {
        Owner      = var.github_org
        Repo       = var.github_project
        Branch     = "master"
        OAuthToken = var.github_token
      }
    }

    action {
      name             = "Base_img_source"
      category         = "Source"
      owner            = "AWS"
      provider         = "ECR"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        RepositoryName = "${var.ecr_repo}"
      }
    }

  }

  stage {
    name = "Build"

    action {
      name             = "Build_docker_image"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["${var.app}"]
      output_artifacts = ["imagedefinitions"]
      version          = "1"

      configuration = {
        ProjectName = "${var.codebuild_project_docker}"
      }
    }

    action {
      name             = "Build_lambda"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["${var.app}"]
      output_artifacts = ["lambda"]
      version          = "1"

      configuration = {
        ProjectName = "${var.codebuild_project_lambda}"
      }
    }

    action {
      name             = "Build_lambda_container"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["${var.app}"]
      output_artifacts = ["lambda_container"]
      version          = "1"

      configuration = {
        ProjectName = "${var.codebuild_project_lambda_container}"
      }
    }

  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["imagedefinitions"]
      version         = "1"

      configuration = {
        ClusterName = var.ecs_cluster_name
        ServiceName = var.service_name
        FileName    = "imagedefinitions.json"
      }
    }

    action {
      name            = "Deploy_lambda_container"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["lambda_container"]
      configuration = {
        ProjectName = "${var.codebuild_deploy_project_lambda_container}"
      }
    }
  }


}

resource "null_resource" "update_source" {
  depends_on = [aws_codepipeline.project]

  provisioner "local-exec" {
    command = "echo test"
  }
}