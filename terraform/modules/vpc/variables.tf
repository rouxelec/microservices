variable "account_name" {
  type        = string
}

variable "project_name" {
  type        = string
  description = "Name of project this VPC is meant to house"
}

variable "namespace" {
  type        = string
}          

variable "region" {  
  type        = string
  description = "Region of the VPC"
}

variable "cidr_block" {  
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidr_blocks" {
  type        = list
  description = "List of public subnet CIDR blocks"
}

variable "availability_zones" {
  type        = list
  description = "List of availability zones"
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "Extra tags to attach to the VPC resources"
}
