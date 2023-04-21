resource "aws_api_gateway_rest_api" "apigw" {
  name = "my-tf-api-gw"
  endpoint_configuration {
    types = [
      "REGIONAL"
    ]
  }
}

resource "aws_api_gateway_method" "api-post" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_rest_api.apigw.root_resource_id
  http_method   = "POST"
  authorization = "NONE"
  depends_on = [
    aws_api_gateway_rest_api.apigw,
    aws_lambda_function.rLambdaFunction
  ]
}


resource "aws_api_gateway_integration" "lambda" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_rest_api.apigw.root_resource_id
  http_method             = aws_api_gateway_method.api-post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.rLambdaFunction.invoke_arn
  credentials             = aws_iam_role.rApiGWRole.arn

  depends_on = [
    aws_lambda_function.rLambdaFunction,
    aws_lambda_permission.apigw_lambda
  ]
}

resource "aws_api_gateway_method_response" "rApiResponse200" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  resource_id = aws_api_gateway_rest_api.apigw.root_resource_id
  http_method = aws_api_gateway_method.api-post.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "rApiInteResponse" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  resource_id = aws_api_gateway_rest_api.apigw.root_resource_id
  http_method = aws_api_gateway_method.api-post.http_method
  status_code = aws_api_gateway_method_response.rApiResponse200.status_code
  depends_on = [
    aws_api_gateway_rest_api.apigw,
    aws_api_gateway_method_response.rApiResponse200,
    aws_api_gateway_method.api-post
  ]
}

resource "aws_api_gateway_deployment" "apigwdep" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.apigw.body))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_method.api-post,
    aws_api_gateway_integration.lambda
  ]
}

resource "aws_api_gateway_stage" "apistage" {
  deployment_id = aws_api_gateway_deployment.apigwdep.id
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  stage_name    = "dev"

  depends_on = [
    aws_cloudwatch_log_group.apigw_logs,
  ]
}


resource "aws_cloudwatch_log_group" "apigw_logs" {
  name              = "/aws/apigateway/${aws_api_gateway_rest_api.apigw.id}/dev"
  retention_in_days = 5
}