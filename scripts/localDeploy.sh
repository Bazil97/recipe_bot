#!/bin/bash
set -e

LAMBDA_DIR="lambda"
ZIP_FILE="lambda.zip"
TF_DIR="infra"
TFVARS_FILE="$TF_DIR/terraform.tfvars"

# === STEP 1: Get bucket name from terraform.tfvars ===
S3_BUCKET=$(awk -F' *= *' '$1 == "s3_bucket" {print $2}' "$TFVARS_FILE" | tr -d '"')

if [[ -z "$S3_BUCKET" ]]; then
  echo "S3 bucket name not found in $TFVARS_FILE"
  exit 1
fi

# === STEP 2: Run Terraform to create bucket ===
echo "Running Terraform to create infrastructure (incl. S3 bucket)..."
cd "$TF_DIR"
terraform init
terraform apply -auto-approve
cd ..

# === STEP 3: Zip Lambda Code ===
echo "Zipping Lambda function..."
if zip -r "$ZIP_FILE" "$LAMBDA_DIR" > /dev/null; then
  echo "Lambda zipped as $ZIP_FILE"
else
  echo "Failed to zip Lambda"
  exit 1
fi

# === STEP 4: Check if ZIP has changed ===
echo "Checking if ZIP has changed..."
LOCAL_HASH=$(sha256sum "$ZIP_FILE" | awk '{print $1}')
REMOTE_HASH=$(aws s3api head-object \
  --bucket "$S3_BUCKET" \
  --key "$ZIP_FILE" \
  --query Metadata.sha256 \
  --output text 2>/dev/null || echo "notfound")

if [ "$LOCAL_HASH" == "$REMOTE_HASH" ]; then
  echo "No changes detected in Lambda ZIP — skipping upload."
else
  echo "Uploading ZIP to S3 with checksum metadata..."
  aws s3api put-object \
    --bucket "$S3_BUCKET" \
    --key "$ZIP_FILE" \
    --body "$ZIP_FILE" \
    --metadata sha256="$LOCAL_HASH"
  echo "✅ Upload complete."
fi

# === STEP 5: Deploy with Terraform ===
echo "Re-running Terraform to deploy Lambda function..."
cd "$TF_DIR"
terraform apply -auto-approve
cd ..

echo "✅ Deployment complete!"