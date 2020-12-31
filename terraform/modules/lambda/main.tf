data "archive_file" "lambda_zip" {
    type          = "zip"
    source_file   = "../../../src/lambda/helloworld.py"
    output_path   = "../../../terraform/temp/helloworld_lambda.zip"
}

resource "aws_lambda_function" "test_lambda" {
  filename         = "../../../terraform/temp/helloworld_lambda.zip"
  function_name    = replace("helloworld-${var.account_name}-${var.project_name}","_","-")
  role             = "arn:aws:iam::881108841750:role/lambda-role-manal-fun-project"
  handler          = "helloworld.lambda_handler"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  runtime          = "python3.7"
}

# resource "aws_iam_role" "iam_for_lambda_tf" {
#   name = replace("lambda-role-${var.account_name}-${var.project_name}","_","-")

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_policy" "lambda-policy" {
#   name        = replace("lambda-policy-${var.account_name}-${var.project_name}","_","-")
#   description = "A lambda policy"

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": [
#         "dynamodb:*"
#       ],
#       "Effect": "Allow",
#       "Resource": "*"
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "test-attach" {
#   role       = aws_iam_role.iam_for_lambda_tf.name
#   policy_arn = aws_iam_policy.lambda-policy.arn
# }

resource aws_lambda_alias helloworld {
  name             = "helloworld"
  description      = "helloworld alias"
  function_name    = aws_lambda_function.test_lambda.arn
  function_version = aws_lambda_function.test_lambda.version
}

resource aws_lambda_permission alb {
  statement_id  = "AllowExecutionFromALB"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
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

resource "aws_ssm_parameter" "terraform_version" {
  name  = "terraform_version"
  type  = "String"
  value = var.terraform_version
}