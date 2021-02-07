resource "aws_codepipeline" "deploy" {
  count    = var.deploy_enabled ? 1 : 0
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
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["${var.app}"]

      configuration = {
        ConnectionArn        = var.codestar_connection_arn
        FullRepositoryId     = "${var.github_org}/${var.github_repository}"
        BranchName           = var.github_branch
        OutputArtifactFormat = "CODE_ZIP"
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
      name             = "Build_${var.app}"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["${var.app}"]
      output_artifacts = var.output_artifacts
      version          = "1"

      configuration = var.configuration
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
  }

  stage {
    name = "Test"

    action {
      name             = "Test_${var.app}"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["${var.app}"]
      output_artifacts = ["test"]
      version          = "1"

      configuration = var.configuration_test
    }
  }

}

resource "aws_codepipeline" "build" {
  count    = var.build_enabled ? 1 : 0
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
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["${var.app}"]

      configuration = {
        ConnectionArn        = var.codestar_connection_arn
        FullRepositoryId     = "${var.github_org}/${var.github_repository}"
        BranchName           = var.github_branch
        OutputArtifactFormat = "CODE_ZIP"
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
      name             = "Build_${var.app}"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["${var.app}"]
      output_artifacts = var.output_artifacts
      version          = "1"

      configuration = var.configuration
    }
  }

    stage {
    name = "Test"

    action {
      name             = "Test_${var.app}"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["${var.app}"]
      output_artifacts = ["test"]
      version          = "1"

      configuration = var.configuration_test
    }
  }
}
