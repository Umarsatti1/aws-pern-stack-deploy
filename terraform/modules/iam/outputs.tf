output "ecs_task_role_arn" {
  description = "IAM Role ARN to attach to ECS task definition"
  value       = aws_iam_role.ecs_task_execution_role.arn
}