resource "aws_ecr_repository" "this" {
  name = var.repository_name

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"

  tags = {
    Name        = var.repository_name
    Environment = var.environment
  }
}