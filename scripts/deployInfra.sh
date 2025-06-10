#!/bin/bash
set -euo pipefail

mkdir -p logs
TIMESTAMP=$(date +"%Y-%m-%d-%H%M%S")
LOG_FILE="logs/infra-${TIMESTAMP}.log"
exec > >(tee -a "$LOG_FILE") 2>&1
export TF_LOG=TRACE
export TF_LOG_PATH=./terraform.log

echo "Starting infrastructure deployment..."

cd infra
terraform init
terraform apply -auto-approve
cd ..

echo "Infrastructure deployment complete."
