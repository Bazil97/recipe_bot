resource "aws_apigatewayv2_api" "recipe_api" {
  name          = "recipe-api"
  protocol_type = "HTTP"
  
}

resource "aws_apigatewayv2_integration" "recipe_integration" {
  api_id             = var.api_id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = var.lambda_invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "recipe_route" {
  api_id    = var.api_id
  route_key = "POST /recipe"
  target    = "integrations/${aws_apigatewayv2_integration.recipe_integration.id}"
  
}

resource "aws_apigatewayv2_stage" "default_stage" {
  api_id = var.api_id
  name   = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "apigw_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  # The source ARN for the API Gateway
  source_arn = "${aws_apigatewayv2_api.recipe_api.execution_arn}/*/*"
}