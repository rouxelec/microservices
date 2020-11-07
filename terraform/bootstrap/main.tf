locals {
    tags = {
        "environment"       =   "dev"
        "technical_contact" =   "francois.rouxel@slalom.com"
        "tenant_owner"      =   "francois.rouxel@slalom.com"
        "owner_group"       =   "fun_project"
        "cost_center"       =   "personal"
        "project"           =   "fun_project"        
    }   
}

terraform{
    required_version=">= 0.12, <= 0.14"
}

provider "aws" {
    region = "ca-central-1"
    version = "~> 3.2"
}

resource "aws_s3_bucket" "terraform_state" {
    bucket = "fun-project-terraform-state-${var.committer}"

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }

    versioning {
        enabled = true
    }

    lifecycle {
        prevent_destroy = true
    }

    tags = local.tags
}

resource "aws_dynamodb_table" "terraform_locks" {
    name    =   "fun-project-terraform-state-lock-${var.committer}"
    billing_mode    =   "PAY_PER_REQUEST"
    hash_key    =   "lockID"

    attribute {
        name    =   "lockID"
        type    =   "S"
    }

    tags = local.tags
}