output "target_group_id" {
  description = "Target group id"
  value       = aws_lb_target_group.front_end.id
}

output "alb_sg_name" {
  description = "name of the sg alb" 
  value       = aws_security_group.allow_http.id
}