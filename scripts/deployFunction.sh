#!/bin/bash
set -euo pipefail

mkdir -p logs
TIMESTAMP=$(date +"%Y-%m-%d-%H%M%S")
LOG_FILE="logs/function-${TIMESTAMP}.log"
exec > >(tee -a "$LOG_FILE") 2>&1

AWS_REGION="eu-west-2"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REPO_NAME="recipebot-ecr"
IMAGE_TAG="latest"
IMAGE_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}:${IMAGE_TAG}"

echo "Building and pushing Lambda Docker image..."

cd lambda
docker build -t ${REPO_NAME} .
cd ..

echo "Authenticating with ECR..."
aws ecr get-login-password --region ${AWS_REGION} | \
docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

echo "Tagging and pushing image..."
docker tag ${REPO_NAME}:latest ${IMAGE_URI}
docker push ${IMAGE_URI}

echo "Updating Lambda function to use image: ${IMAGE_URI}"
cd infra
terraform apply -auto-approve -var="image_uri=${IMAGE_URI}"
cd ..

echo "Function deployment complete."
