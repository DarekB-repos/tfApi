resource "aws_cloudwatch_log_group" "name" {
  name              = "/aws/lambda/test_private_lambda"
  retention_in_days = 3
}


resource "aws_lambda_function" "rLambdaFunction" {
  s3_bucket     = "dariusz-s3-lambda-deploy"
  s3_key        = "lambda_function.zip"
  function_name = "my_private_lambda"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.rLambdaRole.arn
  publish       = true
  memory_size   = 128
  timeout       = 15
  environment {
    variables = {
      SSM_PATH = aws_ssm_parameter.rSsmParameter.name
    }
  }

}


resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rLambdaFunction.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.apigw.id}/*/POST/"

  depends_on = [
    aws_api_gateway_rest_api.apigw
  ]

}
