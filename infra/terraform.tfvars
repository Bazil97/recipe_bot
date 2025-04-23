# Core config
environment         = "dev"
project             = "recipebot"
owner               = "csb"
aws_region          = "eu-west-2"

# S3
s3_bucket_name      = "recipebot-deploy-dev"
force_destroy       = "true"
sse_algorithm       = "AES256"
versioning_status   = "Enabled"

# ECR
ecr_repository_name = "recipebot-ecr"

# Lambda
function_name       = "recipebot-lambda"
image_uri           = "123456789012.dkr.ecr.eu-west-2.amazonaws.com/recipebot-lambda:latest"
