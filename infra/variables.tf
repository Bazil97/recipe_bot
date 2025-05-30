variable "aws_region" {
  description = "AWS region for resources"
  type        = string
}

variable "function_name" {
  description = "Lambda function name"
  type        = string
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  default     = "recipebot-lambda"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "project" {
  description = "Name of the project"
  type        = string
}

variable "owner" {
  description = "Owner or team responsible"
  type        = string
}

variable "force_destroy" {
  description = "Undocumented variable: force_destroy"
  type        = string
}

variable "sse_algorithm" {
  description = "Undocumented variable: sse_algorithm"
  type        = string
}

variable "versioning_status" {
  description = "Undocumented variable: versioning_status"
  type        = string
}

variable "s3_bucket_name" {
  description = "Undocumented variable: bucket_name"
  type        = string
}

variable "image_uri" {
  description = "Undocumented variable: image_uri"
  type        = string
}

variable "openai_api_key" {
  description = "Undocumented variable: openai_api_key"
  type        = string
}