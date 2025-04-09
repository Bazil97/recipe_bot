variable "function_name" {}
variable "image_uri" {}
variable "handler" {}
variable "runtime" {}
variable "lambda_role_arn" {}
variable "openai_api_key" {
  description = "API key for OpenAI"
  type        = string
  sensitive   = true
}