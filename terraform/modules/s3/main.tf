resource "aws_s3_bucket" "releases" {
  bucket = replace("${var.namespace}-${var.region}-${var.account_name}-${var.project_name}-releases","_","-")
  acl    = "private"                   
} 
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.releases.id

  block_public_acls   = true
  block_public_policy = true
}