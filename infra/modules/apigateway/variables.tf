variable "lambda_invoke_arn" {
  description = "The ARN of the Lambda function to be invoked by the API Gateway."
  type        = string
  
}

variable "lambda_function_name" {
  description = "The name of the Lambda function."
  type        = string
  
}

variable "tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
}

variable "api_id" {
  description = "The ID of the API Gateway."
  type        = string
  
}