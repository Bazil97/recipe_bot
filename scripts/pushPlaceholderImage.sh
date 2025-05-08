#!/bin/bash

# Configuration
AWS_REGION="eu-west-2"
REPO_NAME="recipebot-ecr"
IMAGE_TAG="latest"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
IMAGE_TAG="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}:${IMAGE_TAG}"

echo $AWS_ACCOUNT_ID && echo "account id ${AWS_ACCOUNT_ID} exists"

echo "Creating ECR repository..."
aws ecr create-repository --repository-name ${REPO_NAME} --region ${AWS_REGION} || echo "ECR repository already exists."

echo "Pulling AWS Lambda base image..."
docker pull public.ecr.aws/lambda/python:3.11

echo "Tagging AWS Lambda base image as ${IMAGE_TAG}..."
docker tag public.ecr.aws/lambda/python:3.11 ${IMAGE_TAG}

echo "Loging in to Amazon ECR..."
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/"

echo "Pushing placeholde image to ECR..."
docker push ${IMAGE_TAG} && echo "Placeholder image pushed to ECR successfully."