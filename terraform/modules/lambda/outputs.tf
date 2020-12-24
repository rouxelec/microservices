output "aws_lambda_function_arn" {
    value = aws_lambda_function.test_lambda.arn
}

output "aws_lambda_function_name" {
    value = aws_lambda_function.test_lambda.function_name
}

output "aws_lambda_function_alias" {
    value = aws_lambda_alias.helloworld.name
}