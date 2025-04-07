#!/bin/bash
set -e

echo "🐳 Building Lambda deployment package with Docker..."

docker build -t recipebot-lambda .
docker create --name extract-lambda recipebot-lambda
docker cp extract-lambda:/var/task ./lambda-package
docker rm extract-lambda

cd lambda-package
zip -r ../lambda.zip .
cd ..

rm -rf lambda-package

echo "✅ Lambda zip created: lambda/lambda.zip"
