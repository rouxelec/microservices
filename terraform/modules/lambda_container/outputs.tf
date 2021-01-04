output "aws_lambda_function_arn" {
    value = aws_lambda_function.lambda_container.arn
}

output "aws_lambda_function_name" {
    value = aws_lambda_function.lambda_container.function_name
}

output "aws_lambda_function_alias" {
    value = aws_lambda_alias.helloworld.name
}