output "target_group_id" {
  description = "Target group id"
  value       = aws_lb_target_group.docker-tg.id
}

output "lambda_target_group_arn" {
  description = "Lambda Target group arn"
  value       = aws_lb_target_group.lambda-tg.arn
}

output "alb_dns" {
  description = "dns_name of alb" 
  value       = aws_lb.front_end_lb.dns_name
}

output "alb_sg_name" {
  description = "name of the sg alb" 
  value       = aws_security_group.allow_http.id
}