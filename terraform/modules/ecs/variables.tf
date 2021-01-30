# How many containers to run
variable "replicas" {
  default = "1"
}

# The name of the container to run
variable "container_name" {
  default = "app"
}

# The minimum number of containers that should be running.
# Must be at least 1.
# used by both autoscale-perf.tf and autoscale.time.tf
# For production, consider using at least "2".
variable "ecs_autoscale_min_instances" {
  default = "1"
}

# The maximum number of containers that should be running.
# used by both autoscale-perf.tf and autoscale.time.tf
variable "ecs_autoscale_max_instances" {
  default = "8"
}

variable "default_backend_image" {

}

variable "app" {
  type = string
}

variable "environment" {
  type = string
}

variable "container_port" {
  type = string
}

variable "alb_sg_name" {
  type = string
}


variable account_name {
  type = string
}

variable project_name {
  type = string
}

variable namespace {
  type = string
}

variable region {
  type = string
}


variable "vpc_id" {
  type = string
}

variable "target_group_id" {
  type = string
}

variable "logs_retention_in_days" {
  default = 1
}

variable "tags" {
  type = map
}

variable "private_subnets" {
  type = list
}
