variable "environment" {
    description = "environment"
    type = string      
    default="dev"  
}

variable "account_name" {
    type = string
}

variable "project_name" {
    type = string
    default = "fun-project"
}

variable "region" {
    type = string
    default = "us-east-1"
}

variable "namespace" {
    type = string
    default = "training"
}