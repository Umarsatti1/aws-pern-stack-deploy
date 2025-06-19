output "ecs_cluster_id" {
  value       = aws_ecs_cluster.ecs_cluster.id
  description = "ECS cluster ID"
}

output "log_group_name" {
  value       = aws_cloudwatch_log_group.ecs_log_group.name
  description = "CloudWatch Log Group name for ECS"
}

output "ecs_service_name" {
  value       = aws_ecs_service.ecs_service.name
  description = "Name of the ECS service"
}