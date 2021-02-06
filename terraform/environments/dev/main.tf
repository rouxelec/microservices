variable "tags" {
  type = "map"

  default = {
    "project" = "fun-project"
  }
}
module "s3" {
  source       = "../../modules/s3"
  account_name = var.account_name
  project_name = var.project_name
  namespace    = var.namespace
  region       = var.region
}

module "vpc" {
  depends_on = [module.s3]
  source     = "../../modules/vpc"

  account_name = var.account_name
  project_name = var.project_name
  namespace    = var.namespace
  region       = var.region

  cidr_block                = "10.0.0.0/16"
  public_subnet_cidr_blocks = ["10.0.0.0/24", "10.0.1.0/24"]
  availability_zones        = var.availability_zones

}

module "alb" {
  depends_on                = [module.vpc]
  source                    = "../../modules/alb"
  vpc_id                    = module.vpc.id
  public_subnet_cidr_blocks = module.vpc.public_subnet_ids
  project_name              = var.project_name
  namespace                 = var.namespace

}

module "ecr" {
  source        = "../../modules/ecr"
  base_img_name = "base-img"
  app_name      = "hello-world"
  project_name  = var.project_name
  namespace     = var.namespace
}

module "role" {
  source       = "../../modules/role"
  project_name = var.project_name
  namespace    = var.namespace
}

module "dynamodb" {
  source = "../../modules/dynamodb"
}

module "lambda" {
  depends_on              = [module.alb]
  source                  = "../../modules/lambda"
  lambda_target_group_arn = module.alb.lambda_target_group_arn
  account_name            = var.account_name
  project_name            = var.project_name
  namespace               = var.namespace
  region                  = var.region
  terraform_version       = var.terraform_version
}

module "lambda_container" {
  depends_on              = [module.alb, module.codebuild_base_img]
  source                  = "../../modules/lambda_container"
  lambda_target_group_arn = module.alb.lambda_container_target_group_arn
  account_name            = var.account_name
  project_name            = var.project_name
  namespace               = var.namespace
  region                  = var.region
  terraform_version       = var.terraform_version
  image_uri               = module.ecr.ecr_img_repo_url
}

module "codebuild_base_img" {
  source                  = "../../modules/codebuild"
  namespace               = var.namespace
  environment_variables   = var.environment_variables
  source_credential_token = var.github_token
  github_token            = var.github_token
  source_type             = "GITHUB"
  source_location         = "https://github.com/rouxelec/fun_project"
  buildspec               = "src/codebuild/build_base.yaml"
  artifact_type           = "NO_ARTIFACTS"
  private_repository      = "true"
  build_image             = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
  privileged_mode         = true
  code_build_role_arn     = module.role.role_arn
  code_build_project_name = "codebuild_codebase"
  project_name            = var.project_name
  region                  = var.region
  account_name            = var.account_name
  trigger_enabled         = true
}


module "codebuild_app_docker" {
  source                  = "../../modules/codebuild"
  namespace               = var.namespace
  environment_variables   = var.environment_variables
  source_type             = "CODEPIPELINE"
  buildspec               = "src/codebuild/build_hello_world_docker.yaml"
  artifact_type           = "CODEPIPELINE"
  build_image             = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
  privileged_mode         = true
  code_build_role_arn     = module.role.role_arn
  code_build_project_name = "codebuild_app_docker"
  project_name            = var.project_name
  region                  = var.region
  account_name            = var.account_name
  trigger_enabled         = false
}

module "codebuild_app_lambda" {
  source                  = "../../modules/codebuild"
  namespace               = var.namespace
  environment_variables   = var.environment_variables
  source_type             = "CODEPIPELINE"
  buildspec               = "src/codebuild/build_hello_world_lambda.yaml"
  artifact_type           = "CODEPIPELINE"
  build_image             = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
  privileged_mode         = true
  code_build_role_arn     = module.role.role_arn
  code_build_project_name = "codebuild_app_lambda"
  project_name            = var.project_name
  region                  = var.region
  account_name            = var.account_name
  trigger_enabled         = false
}

module "codebuild_app_lambda_container" {
  source                  = "../../modules/codebuild"
  namespace               = var.namespace
  environment_variables   = var.environment_variables
  source_type             = "CODEPIPELINE"
  buildspec               = "src/codebuild/build_hello_world_lambda_container.yaml"
  artifact_type           = "CODEPIPELINE"
  build_image             = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
  privileged_mode         = true
  code_build_role_arn     = module.role.role_arn
  code_build_project_name = "codebuild_app_lambda_container"
  project_name            = var.project_name
  region                  = var.region
  account_name            = var.account_name
  trigger_enabled         = false
}

module "codebuild_deploy_app_ec2" {
  source                  = "../../modules/codebuild"
  namespace               = var.namespace
  environment_variables   = var.environment_variables
  source_type             = "CODEPIPELINE"
  buildspec               = "src/codebuild/deploy_hello_world_ec2.yaml"
  artifact_type           = "CODEPIPELINE"
  build_image             = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
  privileged_mode         = true
  code_build_role_arn     = module.role.role_arn
  code_build_project_name = "codebuild_deploy_app_ec2"
  project_name            = var.project_name
  region                  = var.region
  account_name            = var.account_name
  trigger_enabled         = false
}

module "codepipeline_lambda" {
  source                  = "../../modules/codepipeline"
  codebuild_role_arn      = module.role.role_arn
  configuration           = { ProjectName = module.codebuild_app_lambda.project_name }
  ecr_repo                = module.ecr.ecr_img_repo_name
  github_org              = var.github_org
  github_project          = "fun_project"
  github_token            = var.github_token
  app                     = "hw-lambda"
  releases_bucket_id      = module.s3.s3_bucket_release_name
  project_name            = var.project_name
  region                  = var.region
  account_name            = var.account_name
  namespace               = var.namespace
  output_artifacts        = ["lambda"]
  build_enabled           = true
  deploy_enabled          = false
  github_repository       = var.github_repository
  github_branch           = var.github_branch
  codestar_connection_arn = var.codestar_connection_arn
}

module "codepipeline_lambda_container" {
  source                  = "../../modules/codepipeline"
  codebuild_role_arn      = module.role.role_arn
  configuration           = { ProjectName = module.codebuild_app_lambda_container.project_name }
  ecr_repo                = module.ecr.ecr_img_repo_name
  github_org              = var.github_org
  github_project          = "fun_project"
  github_token            = var.github_token
  app                     = "hw-lambda-container"
  releases_bucket_id      = module.s3.s3_bucket_release_name
  project_name            = var.project_name
  region                  = var.region
  account_name            = var.account_name
  namespace               = var.namespace
  output_artifacts        = ["lambda_container"]
  build_enabled           = true
  deploy_enabled          = false
  github_repository       = var.github_repository
  github_branch           = var.github_branch
  codestar_connection_arn = var.codestar_connection_arn
}

module "codepipeline_ec2" {
  source                  = "../../modules/codepipeline"
  codebuild_role_arn      = module.role.role_arn
  configuration           = { ProjectName = module.codebuild_deploy_app_ec2.project_name }
  ecr_repo                = module.ecr.ecr_img_repo_name
  github_org              = var.github_org
  github_project          = "fun_project"
  github_token            = var.github_token
  app                     = "hw-ec2"
  releases_bucket_id      = module.s3.s3_bucket_release_name
  project_name            = var.project_name
  region                  = var.region
  account_name            = var.account_name
  namespace               = var.namespace
  output_artifacts        = [""]
  build_enabled           = true
  deploy_enabled          = false
  github_repository       = var.github_repository
  github_branch           = var.github_branch
  codestar_connection_arn = var.codestar_connection_arn
}

module "codepipeline_ecs" {
  source                  = "../../modules/codepipeline"
  codebuild_role_arn      = module.role.role_arn
  configuration           = { ProjectName = module.codebuild_app_docker.project_name }
  ecr_repo                = module.ecr.ecr_img_repo_name
  github_org              = var.github_org
  github_project          = "fun_project"
  github_token            = var.github_token
  app                     = "hw-ecs"
  releases_bucket_id      = module.s3.s3_bucket_release_name
  project_name            = var.project_name
  region                  = var.region
  account_name            = var.account_name
  namespace               = var.namespace
  ecs_cluster_name        = module.ecs.ecs_cluster_name
  service_name            = module.ecs.ecs_service_name
  output_artifacts        = ["imagedefinitions"]
  build_enabled           = false
  deploy_enabled          = true
  github_repository       = var.github_repository
  github_branch           = var.github_branch
  codestar_connection_arn = var.codestar_connection_arn
}
module "ecs" {
  source = "../../modules/ecs"

  replicas                    = 1
  container_name              = "hello-world-container"
  ecs_autoscale_min_instances = 1
  ecs_autoscale_max_instances = 2
  app                         = "hello-world"
  environment                 = "dev"
  container_port              = "5000"
  alb_sg_name                 = module.alb.alb_sg_name
  logs_retention_in_days      = 14
  tags                        = var.tags
  private_subnets             = module.vpc.public_subnet_ids
  vpc_id                      = module.vpc.id
  target_group_id             = module.alb.target_group_id
  project_name                = var.project_name
  account_name                = var.account_name
  namespace                   = var.namespace
  region                      = var.region
  default_backend_image       = module.ecr.ecr_img_repo_name
}

module "ec2" {
  source            = "../../modules/ec2"
  vpc_id            = module.vpc.id
  subnet_ids        = module.vpc.public_subnet_ids
  ami               = "ami-0be2609ba883822ec"
  instance_type     = "t2.micro"
  asg_threshold     = "80"
  target_group      = module.alb.ec2_target_group_arn
  configbucket_name = module.s3.s3_bucket_config_name
  app_port          = "5000"
  desired_capacity  = 1
  project_name      = var.project_name
  account_name      = var.account_name
  namespace         = var.namespace
  region            = var.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.22.0"
    }
  }
}

provider "aws" {
  region  = var.region
  version = "~> 3.22.0"
}