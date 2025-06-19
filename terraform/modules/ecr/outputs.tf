output "backend_repo_url" {
  value       = aws_ecr_repository.backend.repository_url
  description = "ECR URL for backend image"
}

output "frontend_repo_url" {
  value       = aws_ecr_repository.frontend.repository_url
  description = "ECR URL for frontend image"
}