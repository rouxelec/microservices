
resource "aws_ssm_parameter" "container_name" {
  name  = "containername"
  type  = "String"
  value = var.container_name
}

resource "aws_ecs_cluster" "app" {
  name = replace("${var.app}-${var.environment}-${var.namespace}-${var.region}-${var.project_name}-cluster", "_", "-")
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = var.tags
}

resource "aws_ssm_parameter" "aws_ecs_cluster_name" {
  name  = "ecs_cluster_name"
  type  = "String"
  value = aws_ecs_cluster.app.name
}

resource "aws_appautoscaling_target" "app_scale_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.app.name}/${aws_ecs_service.app.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  max_capacity       = var.ecs_autoscale_max_instances
  min_capacity       = var.ecs_autoscale_min_instances
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.app}-${var.environment}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn

  # defined in role.tf
  task_role_arn         = aws_iam_role.app_role.arn
  container_definitions = <<DEFINITION
[
  {
    "name": "${var.container_name}",
    "image": "${var.default_backend_image}",
    "essential": true,
    "portMappings": [
      {
        "protocol": "tcp",
        "containerPort": ${var.container_port},
        "hostPort": ${var.container_port}
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/fargate/service/${var.app}-${var.environment}",
        "awslogs-region": "${var.region}",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
DEFINITION


  tags = var.tags
}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [aws_ecs_task_definition.app]

  create_duration = "30s"
}

resource "null_resource" "next" {
  depends_on = [time_sleep.wait_30_seconds]
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http_ecs"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from VPC"
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [var.alb_sg_name]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "app" {
  name                              = replace("${var.app}-${var.environment}-${var.namespace}-${var.region}-${var.project_name}-service", "_", "-")
  cluster                           = aws_ecs_cluster.app.id
  launch_type                       = "FARGATE"
  task_definition                   = aws_ecs_task_definition.app.arn
  desired_count                     = var.replicas
  health_check_grace_period_seconds = 300

  network_configuration {
    security_groups  = [aws_security_group.allow_http.id]
    subnets          = var.private_subnets
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_id
    container_name   = var.container_name
    container_port   = var.container_port
  }

  tags                    = var.tags
  enable_ecs_managed_tags = true
  propagate_tags          = "SERVICE"

  lifecycle {
    ignore_changes = [task_definition]
  }
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = replace("${var.app}-${var.environment}-${var.namespace}-${var.region}-${var.project_name}-ecs-role", "_", "-")
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/fargate/service/${var.app}-${var.environment}"
  retention_in_days = var.logs_retention_in_days
  tags              = var.tags
}


resource "aws_iam_role" "app_role" {
  name = replace("${var.app}-${var.environment}-${var.namespace}-${var.region}-${var.project_name}-app-role", "_", "-")

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_policy" "task-policy" {
  name        = replace("${var.app}-${var.environment}-${var.namespace}-${var.region}-${var.project_name}-task-policy", "_", "-")
  description = "A task policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.app_role.name
  policy_arn = aws_iam_policy.task-policy.arn
}