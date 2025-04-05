provider "aws" {
  region = var.aws_region
}

module "iam" {
  source = "./modules/iam"
  lambda_role_name = "recipebot_lambda_execution_role"
}

module "lambda" {
  source = "./modules/lambda"

  function_name    = var.function_name
  s3_bucket        = var.s3_bucket
  s3_key           = var.lambda_zip
  handler          = "handler.lambda_handler"
  runtime          = "python3.11"
  lambda_role_arn  = module.iam.lambda_role_arn
}
