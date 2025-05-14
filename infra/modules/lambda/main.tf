resource "aws_lambda_function" "this" {
  function_name = var.function_name
  package_type  = "Image"
  image_uri     = var.image_uri
  role = var.lambda_role_arn
  timeout = 300
  memory_size = 256

  environment {
    variables = {
      OPENAI_API_KEY = var.openai_api_key
    }
  }
}

resource "aws_apigatewayv2_api" "recipe_api" {
  name          = "recipe-api"
  protocol_type = "HTTP"
  
}

resource "aws_apigatewayv2_integration" "recipe_integration" {
  api_id             = aws_apigatewayv2_api.recipe_api.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = module.lambda.lambda_invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "recipe_route" {
  api_id    = aws_apigatewayv2_api.recipe_api.id
  route_key = "POST /recipe"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
  
}

resource "aws_apigatewayv2_stage" "default_stage" {
  api_id = aws_apigatewayv2_api.recipe_api.id
  name   = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "apigw_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  # The source ARN for the API Gateway
  source_arn = "${aws_apigatewayv2_api.recipe_api.execution_arn}/*/*"
}