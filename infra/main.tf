locals {
  common_tags = {
    environment = var.environment
    project     = var.project
    owner       = var.owner
  }
}

provider "aws" {
  region = var.aws_region
}

module "s3" {
  source      = "./modules/s3"
  s3_bucket_name = var.s3_bucket_name
  force_destroy = var.force_destroy
  tags        = local.common_tags
  sse_algorithm = var.sse_algorithm
  versioning_status = var.versioning_status
}

module "ecr" {
  source          = "./modules/ecr"
  repository_name = var.ecr_repository_name
  tags            = local.common_tags
}

module "iam" {
  source = "./modules/iam"
  lambda_role_name = "recipebot_lambda_execution_role"
}

module "lambda" {
  source            = "./modules/lambda"
  function_name     = var.function_name
  image_uri         = var.image_uri
  lambda_role_arn   = module.iam.lambda_role_arn
  openai_api_key    = var.openai_api_key
}

module "apigateway" {
  source            = "./modules/apigateway"
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
  lambda_function_name = module.lambda.lambda_function_name
  api_id            = module.apigateway.api_id
  tags              = local.common_tags
}

module "vpc" {
  source              = "./modules/vpc"
  project             = var.project
  vpc_cidr_block      = var.vpc_cidr_block
  availability_zones  = var.availability_zones
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  common_tags         = local.common_tags
}