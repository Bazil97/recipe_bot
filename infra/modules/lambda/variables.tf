variable "image_uri" {
  description = "ECR container image URI"
  type        = string
}

variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "lambda_role_arn" {
  description = "IAM role ARN for Lambda execution"
  type        = string
}

variable "openai_api_key" {
  description = "OpenAI API key passed into the function as env var"
  type        = string
  sensitive   = true
}