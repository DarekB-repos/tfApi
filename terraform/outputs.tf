output "invokearn" {
  value = aws_lambda_function.rLambdaFunction.invoke_arn
}

output "lambda_arn" {
  value = aws_lambda_function.rLambdaFunction.arn
}

output "exec_arn" {
  value = aws_api_gateway_rest_api.apigw.execution_arn
}

output "awsAccountId" {
  value = data.aws_caller_identity.current.account_id
}