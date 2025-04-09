output "lambda_function_name" {
  value = module.lambda.lambda_function_name
}

output "bucket_name" {
  value = module.s3.s3_bucket_name
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}