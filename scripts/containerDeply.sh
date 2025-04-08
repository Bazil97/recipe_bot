#!/bin/bash
set -euo pipefail

# Create logs directory if it doesn't exist
mkdir -p logs

# Timestamped log file
TIMESTAMP=$(date +"%Y-%m-%d-%H%M%S")
LOG_FILE="logs/deploy-${TIMESTAMP}.log"

# Start logging
exec > >(tee -a "$LOG_FILE") 2>&1

# Configuration
AWS_REGION="eu-west-1"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REPO_NAME="recipebot-lambda"
IMAGE_TAG="latest"
IMAGE_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}:${IMAGE_TAG}"

echo "Starting deployment at $(date)"
echo "Logging to $LOG_FILE"

# Step 1: Build the Docker image
cd lambda
echo "Building Docker image..."
docker build -t ${REPO_NAME} .
cd ..

# Step 2: Create the ECR repository if it does not exist
echo "Ensuring ECR repository exists..."
aws ecr describe-repositories --repository-names ${REPO_NAME} --region ${AWS_REGION} >/dev/null 2>&1 || \
aws ecr create-repository --repository-name ${REPO_NAME} --region ${AWS_REGION}

# Step 3: Authenticate Docker to ECR
echo "Authenticating Docker to ECR..."
aws ecr get-login-password --region ${AWS_REGION} | \
docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# Step 4: Tag and push image to ECR
echo "Tagging and pushing image to ECR..."
docker tag ${REPO_NAME}:latest ${IMAGE_URI}
docker push ${IMAGE_URI}

# Step 5: Run Terraform to deploy or update the Lambda function
echo "Deploying Lambda with Terraform..."
cd infra
terraform init
terraform apply -auto-approve -var="image_uri=${IMAGE_URI}"
cd ..

echo "Deployment complete at $(date)"
echo "Lambda function is now running from image: ${IMAGE_URI}"
