resource "aws_ecr_repository" "backend" {
  name = "${var.project}-backend"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Project = var.project
  }
}

resource "aws_ecr_repository" "frontend" {
  name = "${var.project}-frontend"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Project = var.project
  }
}