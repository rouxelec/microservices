module "codebuild_deploy_app_lc" {
  source                  = "../codebuild"
  namespace               = var.namespace
  source_type             = "CODEPIPELINE"
  buildspec               = "src/codebuild/deploy_hello_world_lambda_container.yaml"
  artifact_type           = "CODEPIPELINE"
  build_image             = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
  privileged_mode         = true
  code_build_role_arn     = var.codebuild_role_arn
  code_build_project_name = "codebuild_deploy_lc"
  project_name            = var.project_name
  region                  = var.region
  account_name            = var.account_name
  trigger_enabled         = false
}

module "codebuild_test_lc" {
  source                  = "../codebuild"
  namespace               = var.namespace
  source_credential_token = var.github_token
  github_token            = var.github_token
  source_type             = "GITHUB"
  source_location         = "https://github.com/rouxelec/fun_project"
  buildspec               = "src/codebuild/build_test_lc.yaml"
  artifact_type           = "NO_ARTIFACTS"
  private_repository      = "true"
  build_image             = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
  privileged_mode         = true
  code_build_role_arn     = var.codebuild_role_arn
  code_build_project_name = "codebuild_test_lc"
  project_name            = var.project_name
  region                  = var.region
  account_name            = var.account_name
  trigger_enabled         = true
}

module "codebuild_app_lambda_container" {
  source                  = "../codebuild"
  namespace               = var.namespace
  source_type             = "CODEPIPELINE"
  buildspec               = "src/codebuild/build_hello_world_lambda_container.yaml"
  artifact_type           = "CODEPIPELINE"
  build_image             = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
  privileged_mode         = true
  code_build_role_arn     = var.codebuild_role_arn
  code_build_project_name = "codebuild_app_lambda_container"
  project_name            = var.project_name
  region                  = var.region
  account_name            = var.account_name
  trigger_enabled         = false
}

resource "aws_codepipeline" "build" {
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

      configuration = { ProjectName = module.codebuild_app_lambda_container.project_name }
    }
  }
stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts  = ["${var.app}"]
      configuration = { ProjectName = module.codebuild_deploy_app_lc.project_name }
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

      configuration       = { ProjectName = module.codebuild_test_lc.project_name }
    }
  }
    
}
