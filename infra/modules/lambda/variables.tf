variable "function_name" {}
variable "s3_bucket" {}
variable "s3_key" {}
variable "handler" {}
variable "runtime" {}
variable "lambda_role_arn" {}
variable "openai_api_key" {
  description = "API key for OpenAI"
  type        = string
  sensitive   = true
}