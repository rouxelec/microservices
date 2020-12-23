resource "aws_iam_role" "default" {
  count                 = var.enabled ? 1 : 0
  name                  = replace("code_build_role-${var.namespace}-${var.project_name}","_","-")
  assume_role_policy    = data.aws_iam_policy_document.role.json
  force_detach_policies = true
}

data "aws_iam_policy_document" "role" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com","codepipeline.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_policy" "default" {
  count  = var.enabled ? 1 : 0
  name   = replace("code_build_policy-${var.namespace}-${var.project_name}","_","-")
  path   = "/service-role/"
  policy = data.aws_iam_policy_document.permissions.json
}

data "aws_iam_policy_document" "permissions" {
  statement {
    sid = ""

    actions = compact(concat([
      "codecommit:GitPull",
      "ecs:*",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "iam:PassRole",
      "ssm:*",
      "secretsmanager:GetSecretValue",
      "s3:*",
      "codebuild:*",
      "ecr:*",
      "dynamodb:*",
      "codestar-connections:UseConnection"
    ], var.extra_permissions))

    effect = "Allow"

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy_attachment" "default" {
  count      = var.enabled ? 1 : 0
  policy_arn = join("", aws_iam_policy.default.*.arn)
  role       = join("", aws_iam_role.default.*.id)
}

