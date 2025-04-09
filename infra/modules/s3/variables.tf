variable "s3_bucket_name" {
  description = "Undocumented variable: bucket_name"
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

variable "tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
}