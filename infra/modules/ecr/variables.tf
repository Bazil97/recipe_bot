variable "repository_name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g. dev, prod)"
  type        = string
}