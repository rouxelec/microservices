locals {
    tags = {
        "environment"       =   "dev"
        "technical_contact" =   "manal.boucenna@slalom.com"
        "tenant_owner"      =   "manal.boucenna@slalom.com"        
        "cost_center"       =   "personal"
        "project"           =   var.project_name       
    }   
}

terraform{
    required_version=">= 0.12, <= 0.14"
}

provider "aws" {
    region = var.region
    version = "~> 3.2"
}

resource "aws_s3_bucket" "terraform_state" {
    bucket = "${var.account_name}-${var.project_name}-terraform-state"

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
        prevent_destroy = false
    }

    tags = local.tags
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_dynamodb_table" "terraform_locks" {
    name    =   "${var.account_name}-${var.project_name}-terraform-state-lock"
    billing_mode    =   "PAY_PER_REQUEST"
    hash_key    =   "LockID"

    attribute {
        name    =   "LockID"
        type    =   "S"
    }

    tags = local.tags
}