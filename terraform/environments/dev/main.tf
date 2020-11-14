
module "s3" {
  source                  = "../../modules/s3"
  account_name            = var.account_name
  project_name            = "fun-project"
}

module "codebuild_base_img" {
  source                      = "../../modules/codebuild"
  namespace                   = var.namespace
  stage                       = var.stage
  name                        = "base-img"
  cache_bucket_suffix_enabled = var.cache_bucket_suffix_enabled
  environment_variables       = var.environment_variables
  cache_expiration_days       = var.cache_expiration_days
  cache_type                  = var.cache_type
  source_credential_token     = var.github_token 
  github_token                = var.github_token
  source_type                 = "GITHUB"
  source_location             = "https://github.com/rouxelec/fun_project"
  buildspec                   = "src/codebuild/build_base.yaml"
  artifact_type               = "NO_ARTIFACTS"
  private_repository          = "true"
  build_image                 = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
  privileged_mode             = true
}

module "codebuild_app" {
  source                      = "../../modules/codebuild"
  namespace                   = var.namespace
  stage                       = var.stage
  name                        = "app"
  cache_bucket_suffix_enabled = var.cache_bucket_suffix_enabled
  environment_variables       = var.environment_variables
  cache_expiration_days       = var.cache_expiration_days
  cache_type                  = var.cache_type
  source_type                 = "CODEPIPELINE"
  buildspec                   = "src/codebuild/build_hello_world.yaml"
  artifact_type               = "CODEPIPELINE"
  build_image                 = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
  privileged_mode             = true
}

module "codepipeline_app" {
  source                  = "../../modules/codepipeline"
  codebuild_role_arn      = module.codebuild_app.role_arn
  codebuild_project_name  = module.codebuild_app.project_name
  ecr_repo                = "fun_project"
  github_org              = "https://github.com/rouxelec"
  github_project          = "fun_project"
  github_token            = var.github_token
  app                     = "app"
  releases_bucket_id      = module.s3.s3_bucket_release_name

}

provider "aws" {
  region = var.region
  version = "~> 3.2"
}