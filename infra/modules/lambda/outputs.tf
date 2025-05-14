output "lambda_function_name" {
  value = aws_lambda_function.this.function_name
}

output "api_endpoint" {
  value = aws_apigatewayv2_api.recipe_api.api_endpoint
}