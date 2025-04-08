# Recipebot Platform - Cold Deploy Build Journey

This repository documents the development journey and infrastructure setup for the **Recipebot** platform, a serverless application that generates recipe suggestions using a containerized AWS Lambda function powered by OpenAI.

---

## 📌 Project Goal
To build a scalable, maintainable, and professional-grade application that:

- Accepts a list of ingredients via a JSON payload
- Uses a language model (OpenAI) to generate a relevant recipe
- Packages the Lambda function using Docker
- Uses Terraform for all infrastructure provisioning
- Deploys via scripts with clear separation between infrastructure and application

---

## 🚧 Build Philosophy
> "Build the house first, then add the furniture."

The project was designed around a hands-on, learning-first approach where everything was built and deployed manually before introducing automation.

---

## 🧱 Infrastructure Overview

### Core Components
- **AWS Lambda**: Hosts the containerized recipe function
- **Amazon ECR**: Stores Docker images used by Lambda
- **Terraform**: Used for infrastructure-as-code (modular)
- **AWS IAM**: Provides permissions for Lambda execution
- **Docker**: Used to build a custom runtime environment

### Modules
- `ecr/`: Creates a container registry
- `lambda/`: Deploys a Lambda function from an image
- `iam/`: Manages IAM roles and policies

---

## 🧪 Cold Deployment Process

This is the manual, first-time deployment process to create and test the full stack from scratch.

### 1. Deploy Infrastructure
```bash
./scripts/deployInfra.sh
```
This creates the ECR repository, IAM roles, and an initial Lambda function.

### 2. Build and Push Docker Image
```bash
cd lambda
./build.sh
```
Builds the image using the AWS Lambda base image and zips the contents (optional).

Or push directly to ECR:
```bash
./scripts/deployFunction.sh
```
This script:
- Builds the Docker image
- Authenticates with ECR
- Pushes the image
- Applies Terraform to update Lambda with the new image URI

### 3. Invoke Lambda for Testing
```bash
aws lambda invoke \
  --function-name recipebot-lambda \
  --payload '{"ingredients":["onion", "chickpeas", "garlic"]}' \
  response.json
```

---

## 🧰 Script Structure

| Script | Purpose |
|--------|---------|
| `deployInfra.sh` | Provisions all AWS infrastructure using Terraform |
| `deployFunction.sh` | Builds and deploys Docker image to ECR and updates Lambda |
| `build.sh` | Optional step to zip Lambda function using Docker |

Each script logs output to `logs/` with timestamps for debugging and auditing.

---

## 💡 Design Decisions

| Area | Decision | Rationale |
|------|----------|-----------|
| Infrastructure | Terraform IaC | Enables repeatable, testable, and modular deployments |
| Lambda packaging | Docker | Allows full runtime control and dependency bundling |
| ECR | Managed via Terraform module | Keeps infra declarative and clean |
| Deployment | Manual (cold deploy first) | Enables deep understanding before automation |
| Logging | All scripts log to file | Professional and maintainable debugging experience |
| CI/CD | Deferred | Will be introduced after mastering manual flow |

---

## 📈 Next Steps
- Introduce CI/CD with GitHub Actions
- Add support for multiple environments (dev, test, prod)
- Implement version tagging for Docker images
- Secure API integration with Secrets Manager or Parameter Store

---

## 🗂️ Repository Structure

```
.
├── infra/                  # Terraform modules and root configs
│   ├── main.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   └── modules/
│       ├── ecr/
│       ├── lambda/
│       └── iam/
├── lambda/                # Dockerized Lambda function code
│   ├── Dockerfile
│   ├── handler.py
│   ├── requirements.txt
│   └── build.sh
├── scripts/               # Deployment scripts
│   ├── deployInfra.sh
│   └── deployFunction.sh
├── logs/                  # Timestamped log files
└── README.md              # This file
```

---

## 🖼️ Diagrams
> To be added: System architecture, cold deploy flow, and CI/CD transition diagram.

---

## 📜 License
MIT License (or other, based on your preference).

---

This project represents a hands-on, high-standard approach to serverless application development. Every component is structured, modular, and designed with production-readiness in mind.