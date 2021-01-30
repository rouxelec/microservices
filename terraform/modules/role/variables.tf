variable "extra_permissions" {
  type        = list
  default     = []
  description = "List of action strings which will be added to IAM service account permissions."
}


variable "enabled" {
  type        = bool
  default     = true
  description = "A boolean to enable/disable resource creation"
}


variable project_name {
  type = string
}

variable namespace {
  type = string
}
