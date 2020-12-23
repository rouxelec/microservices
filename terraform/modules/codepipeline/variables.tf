variable codebuild_role_arn {
    type = string
}

variable codebuild_project_docker {
    type = string
}

variable codebuild_project_lambda {
    type = string
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
    type = string
}

variable service_name {
    type = string
}

variable "project_name" {
  type        = string  
}

variable "account_name" {
  type        = string  
}

variable "region" {
  type        = string  
}

variable namespace {
    type = string
}