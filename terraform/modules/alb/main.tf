resource "aws_lb" "front_end_lb" {
  name               = "lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http.id]
  subnets            = var.public_subnet_cidr_blocks

  enable_deletion_protection = false

}

resource "aws_lb_target_group" "front_end" {
  name        = "lb-tg"
  port        = 5000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    path      = "/"
    port      = 5000
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.front_end_lb.arn
  port              = "80"
  protocol          = "HTTP"
 
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end.arn
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
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