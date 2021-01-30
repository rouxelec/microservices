output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = ""
}

output "s3_bucket_name" {
  value       = aws_s3_bucket.terraform_state.id
  description = ""
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
}