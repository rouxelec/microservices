output "target_group_id" {
  description = "Target group id"
  value       = aws_lb_target_group.ecs-tg.id
}

output "ec2_target_group_arn" {
  description = "ec2 Target group id"
  value       = aws_lb_target_group.ec2-tg.arn
}

output "lambda_target_group_arn" {
  description = "Lambda Target group arn"
  value       = aws_lb_target_group.lambda-tg.arn
}

output "lambda_container_target_group_arn" {
  description = "Lambda container Target group arn"
  value       = aws_lb_target_group.lambda-container-tg.arn
}

output "alb_dns" {
  description = "dns_name of alb"
  value       = aws_lb.front_end_lb.dns_name
}

output "alb_sg_name" {
  description = "name of the sg alb"
  value       = aws_security_group.allow_http.id
}

output "alb_id" {
  description = "dns_name of alb"
  value       = aws_lb.front_end_lb.id
}