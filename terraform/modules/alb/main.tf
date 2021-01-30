resource "aws_lb" "front_end_lb" {
  name               = replace("${var.namespace}-${var.project_name}", "_", "-")
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http.id]
  subnets            = var.public_subnet_cidr_blocks

  enable_deletion_protection = false

}

resource "aws_lb_target_group" "docker-tg" {
  name        = replace("docker-tg-${var.namespace}-${var.project_name}", "_", "-")
  port        = 5000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    path = "/healthcheck"
    port = 5000
  }
}

resource "aws_lb_target_group" "ec2-tg" {
  name        = replace("ec2-tg-${var.namespace}-${var.project_name}", "_", "-")
  port        = 5000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
  health_check {
    path = "/healthcheck"
    port = 5000
  }
}

resource "aws_lb_target_group" "lambda-tg" {
  name        = replace("lambda-tg-${var.namespace}-${var.project_name}", "_", "-")
  target_type = "lambda"
}

resource "aws_lb_target_group" "lambda-container-tg" {
  name        = replace("lambda-c-tg-${var.namespace}-${var.project_name}", "_", "-")
  target_type = "lambda"
  port        = 9000
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.front_end_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    forward {
      stickiness {
        duration = 1
        enabled  = false
      }
      target_group {
        arn    = aws_lb_target_group.docker-tg.arn
        weight = 25
      }
      target_group {
        arn    = aws_lb_target_group.ec2-tg.arn
        weight = 25
      }
      target_group {
        arn    = aws_lb_target_group.lambda-tg.arn
        weight = 25
      }
      target_group {
        arn    = aws_lb_target_group.lambda-container-tg.arn
        weight = 25
      }
    }
  }
}

resource "aws_security_group" "allow_http" {
  name        = replace("allow-http-${var.namespace}-${var.project_name}", "_", "-")
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
