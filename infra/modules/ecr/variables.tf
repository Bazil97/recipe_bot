variable "tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
}

variable "repository_name" {
  description = "The name of the ECR repository"
  type        = string
}
