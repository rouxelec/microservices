resource "aws_s3_bucket" "releases" {
  bucket = replace("${var.namespace}-${var.region}-${var.account_name}-${var.project_name}-releases", "_", "-")
  acl    = "private"
}
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.releases.id

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_bucket" "config" {
  bucket = replace("${var.namespace}-${var.region}-${var.account_name}-${var.project_name}-config", "_", "-")
  acl    = "private"
}
resource "aws_s3_bucket_public_access_block" "config" {
  bucket = aws_s3_bucket.config.id

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_ssm_parameter" "s3_config_bucket" {
  name  = "s3_config_bucket"
  type  = "String"
  value = aws_s3_bucket.config.id
}

resource "aws_ssm_parameter" "region" {
  name  = "region"
  type  = "String"
  value = var.region
}

resource "null_resource" "update_source" {
  depends_on = [aws_s3_bucket.config]

  provisioner "local-exec" {
    command = "aws s3 cp terraform.tfvars s3://${aws_s3_bucket.config.id}"
  }
}