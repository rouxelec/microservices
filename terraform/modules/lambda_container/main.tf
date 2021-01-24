resource "aws_lambda_function" "lambda_container" {
  function_name    = replace("helloworld-v2-${var.namespace}-${var.region}-${var.account_name}-${var.project_name}","_","-")
  role             = "${aws_iam_role.iam_for_lambda_tf.arn}"
  image_uri        = "${var.image_uri}:latest"
  package_type     = "Image"
  timeout = 30
}

resource "aws_iam_role" "iam_for_lambda_tf" {
  name = replace("lambda-container-role-${var.namespace}-${var.region}-${var.account_name}-${var.project_name}","_","-")

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda-policy" {
  name        = replace("lambda-container-policy-${var.namespace}-${var.region}-${var.account_name}-${var.project_name}","_","-")
  description = "A lambda policy"

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
  role       = aws_iam_role.iam_for_lambda_tf.name
  policy_arn = aws_iam_policy.lambda-policy.arn
}

resource aws_lambda_alias helloworld {
  name             = "helloworld_container"
  description      = "helloworld container alias"
  function_name    = aws_lambda_function.lambda_container.arn
  function_version = aws_lambda_function.lambda_container.version
}

resource aws_lambda_permission alb {
  statement_id  = "AllowExecutionFromALB"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_container.function_name
  principal     = "elasticloadbalancing.amazonaws.com"
  qualifier     = aws_lambda_alias.helloworld.name
  source_arn    = var.lambda_target_group_arn
}


resource aws_lb_target_group_attachment lambda_attach {
  target_group_arn = var.lambda_target_group_arn
  target_id        = aws_lambda_alias.helloworld.arn
  depends_on = [
    aws_lambda_permission.alb
  ]
}
