
variable "tags" {
  type = "map"

  default = {
    "project" = "fun-project"
  }
}
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
  ecs_cluster_name        = "hello-world-cluster"
  service_name            = "hello-world-service"


}

module "ecr" {
  source                  = "../../modules/ecr"
  base_img_name           = "base-img"
  app_name                = "hello-world"
}

module "alb" {
  source                    = "../../modules/alb"
  vpc_id                    = module.vpc.id
  public_subnet_cidr_blocks = module.vpc.public_subnet_ids
}

module "vpc" {
  source = "../../modules/vpc"

  name = "my-vpc"
  region = "ca-central-1"
  cidr_block = "10.0.0.0/16"
  public_subnet_cidr_blocks = ["10.0.0.0/24", "10.0.1.0/24"]
  availability_zones = ["ca-central-1a", "ca-central-1b"]

  project = var.project_name
}


module "ecs" {
  source                      = "../../modules/ecs"

  replicas                    = 1
  container_name              = "hello-world-container"
  ecs_autoscale_min_instances = 1
  ecs_autoscale_max_instances = 2
  app                         = "hello-world"
  environment                 = "dev"
  container_port              = "5000"
  alb_sg_name                 = module.alb.alb_sg_name
  region                      = var.region
  logs_retention_in_days      = 14
  tags                        = var.tags
  private_subnets             = module.vpc.public_subnet_ids
  vpc_id                      = module.vpc.id
  target_group_id             = module.alb.target_group_id

}

provider "aws" {
  region = var.region
  version = "~> 3.2"
}