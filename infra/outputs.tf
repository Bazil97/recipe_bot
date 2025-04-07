output "lambda_function_name" {
  value = module.lambda.lambda_function_name
}

output "bucket_name" {
  value = module.s3_bucket.bucket_name
}