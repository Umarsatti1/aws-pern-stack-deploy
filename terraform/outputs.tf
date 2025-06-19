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

output "ecs_task_role_arn" {
  value       = module.iam.ecs_task_role_arn
  description = "IAM Role ARN used by ECS Task"
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnets
  description = "Private subnet IDs used by ECS service"
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnets
  description = "Public subnet IDs used by ALB"
}