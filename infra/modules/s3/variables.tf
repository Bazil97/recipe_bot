variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "force_destroy" {
  description = "Allow Terraform to destroy non-empty bucket"
  type        = bool
}

variable "versioning_status" {
  description = "Bucket versioning status (e.g., Enabled)"
  type        = string
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm (e.g., AES256)"
  type        = string
}

variable "tags" {
  description = "Common tags applied to the bucket"
  type        = map(string)
}