

module "codebuild" {
  source                      = "../../modules/codebuild"
  namespace                   = var.namespace
  stage                       = var.stage
  name                        = var.name
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

provider "aws" {
  region = var.region
  version = "~> 3.2"
}