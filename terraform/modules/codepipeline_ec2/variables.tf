variable codebuild_role_arn {
  type = string
}

variable "output_artifacts" {
  type = list
}

variable "deploy_enabled" {
  type = bool
}

variable "build_enabled" {
  type = bool
}

variable releases_bucket_id {
  type = string
}

variable github_org {
  type = string
}

variable github_project {
  type = string
}

variable ecr_repo {
  type = string
}

variable github_token {
  type = string
}

variable app {
  type = string
}

variable ecs_cluster_name {
  type    = string
  default = ""
}

variable service_name {
  type    = string
  default = ""
}

variable "project_name" {
  type = string
}

variable "account_name" {
  type = string
}

variable "region" {
  type = string
}

variable namespace {
  type = string
}

variable github_repository {
  default = ""
}

variable github_branch {
  default = ""
}

variable codestar_connection_arn {
  default = ""
}