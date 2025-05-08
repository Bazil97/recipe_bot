resource "aws_lambda_function" "this" {
  function_name = var.function_name
  package_type  = "Image"
  image_uri     = var.image_uri
  role = var.lambda_role_arn
  timeout = 30
  memory_size = 256

  environment {
    variables = {
      OPENAI_API_KEY = var.openai_api_key
    }
  }
}