variable "aws_region" {
  description = "AWS region to deploy into"
  default     = "eu-west-1"
}

variable "s3_bucket" {
  description = "S3 bucket containing Lambda package"
}

variable "lambda_zip" {
  description = "S3 key of Lambda ZIP file"
}