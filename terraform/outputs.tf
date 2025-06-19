output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "Public DNS name of the ALB"
}

output "ecr_repo_urls" {
  value = {
    backend  = module.ecr.backend_repo_url
    frontend = module.ecr.frontend_repo_url
  }
}