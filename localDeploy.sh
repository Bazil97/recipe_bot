#!/bin/bash

set -e  # Exit immediately on any error

# === CONFIG ===
LAMBDA_DIR="lambda"
ZIP_FILE="lambda.zip"
TF_DIR="infra"
TFVARS_FILE="$TF_DIR/terraform.tfvars"

# === STEP 1: Extract bucket name from terraform.tfvars ===
S3_BUCKET=$(awk -F' *= *' '$1 == "s3_bucket" {print $2}' "$TFVARS_FILE" | tr -d '"')

if [[ -z "$S3_BUCKET" ]]; then
  echo "S3 bucket name not found in $TFVARS_FILE"
  exit 1
fi

echo "Packaging Lambda from $LAMBDA_DIR/..."
cd "$LAMBDA_DIR"
echo "📦 Zipping Lambda files..."
if zip -r "../$ZIP_FILE" . > /dev/null; then
  echo "✅ Lambda zipped successfully: $ZIP_FILE"
else
  echo "❌ Failed to zip Lambda files"
  exit 1
fi
cd ..

echo "Uploading $ZIP_FILE to s3://$S3_BUCKET/$ZIP_FILE..."
aws s3 cp "$ZIP_FILE" "s3://$S3_BUCKET/$ZIP_FILE"

echo "Deploying with Terraform..."
cd "$TF_DIR"
terraform init
terraform apply -auto-approve
cd ..

echo "✅ Deployment complete!"