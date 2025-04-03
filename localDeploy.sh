#!/bin/bash

LAMBDA_DIR="lambda"
ZIP_FILE="lambda.zip"
TF_DIR="infra"
AWS_REGION="eu-west-1"

# Read bucket from terraform.tfvars
S3_BUCKET=$(awk -F' *= *' '$1 == "s3_bucket" {print $2}' "$TF_DIR/terraform.tfvars" | tr -d '"')

echo "📦 Packaging Lambda..."
cd "$LAMBDA_DIR" || exit 1
zip -r "../$ZIP_FILE" . > /dev/null
cd - > /dev/null

echo "☁️  Uploading to S3 bucket $S3_BUCKET..."
aws s3 cp "$ZIP_FILE" "s3://$S3_BUCKET/$ZIP_FILE" --region "$AWS_REGION"

echo "🚀 Running Terraform..."
cd "$TF_DIR" || exit 1
terraform init
terraform apply -auto-approve

cd - > /dev/null
echo "✅ Done!"
