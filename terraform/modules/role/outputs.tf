output "role_id" {
  description = "IAM Role ID"
  value       = join("", aws_iam_role.default.*.id)
}

output "role_arn" {
  description = "IAM Role ARN"
  value       = join("", aws_iam_role.default.*.arn)
}