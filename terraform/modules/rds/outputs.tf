output "db_username" {
  value = var.db_username
}

output "db_password" {
  value = var.db_password
}

output "db_name" {
  value = var.db_name
}

output "db_port" {
  value = var.db_port
}

output "rds_endpoint" {
  value       = aws_db_instance.db_instance.endpoint
  description = "RDS instance endpoint"
}