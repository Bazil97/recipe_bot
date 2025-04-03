variable "aws_region" {
  description = "AWS region for resources"
  type        = string
}

variable "s3_bucket" {
  description = "S3 bucket containing Lambda ZIP"
  type        = string
}

variable "lambda_zip" {
  description = "Key of the Lambda ZIP in S3"
  type        = string
}

variable "function_name" {
  description = "Lambda function name"
  type        = string
}