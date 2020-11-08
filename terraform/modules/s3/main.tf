resource "aws_s3_bucket" "releases" {
  bucket = "${var.account_name}-${var.project_name}-releases"
  acl    = "private"                   
} 
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.releases.id

  block_public_acls   = true
  block_public_policy = true
}