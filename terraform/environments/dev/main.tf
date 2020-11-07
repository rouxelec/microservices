

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
  source_type                 = "GITHUB"
  source_location             = "https://github.com/rouxelec/fun_project"
  buildspec                   = "src/codebuild/build_base.yaml"
}

provider "aws" {
  region = var.region
  version = "~> 3.2"
}