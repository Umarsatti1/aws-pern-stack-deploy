output "ecs_sg_id" {
  value       = aws_security_group.ecs_sg.id
  description = "Security group ID for ECS service"
}

output "rds_sg_id" {
  value       = aws_security_group.rds_sg.id
  description = "Security group ID for RDS instance"
}

output "alb_sg_id" {
  value       = aws_security_group.alb_sg.id
  description = "Security group ID for ALB"
}