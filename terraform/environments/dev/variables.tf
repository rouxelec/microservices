variable "region" {
  type        = string
  description = "AWS region"
}

variable "namespace" {
  type        = string
  description = "Namespace, which could be your organization name, e.g. 'eg' or 'cp'"
}

variable "environment_variables" {
  type = list(object(
    {
      name  = string
      value = string
  }))

  default = [
    {
      name  = "NO_ADDITIONAL_BUILD_VARS"
      value = "TRUE"
  }]

  description = "A list of maps, that contain both the key 'name' and the key 'value' to be used as additional environment variables for the build"
}

variable "github_token" {
  type = string
}

variable "github_org" {
  type = string
}

variable "account_name" {
  type = string
}

variable "project_name" {
  type = string
}

variable "availability_zones" {
  type = list
}

variable "terraform_version" {
  type    = string
  default = "0.13.5"
}

variable "repo_uri" {
  type    = string
  default = ""
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