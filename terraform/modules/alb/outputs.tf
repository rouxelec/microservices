output "target_group_id" {
  description = "Target group id"
  value       = aws_lb_target_group.front_end.id
}