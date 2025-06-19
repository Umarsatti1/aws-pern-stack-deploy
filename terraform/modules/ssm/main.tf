resource "aws_ssm_parameter" "db_user" {
  name        = "${var.prefix}/DB_USER"
  type        = "String"
  value       = var.db_username
}

resource "aws_ssm_parameter" "db_password" {
  name        = "${var.prefix}/DB_PASSWORD"
  type        = "SecureString"
  value       = var.db_password
}

resource "aws_ssm_parameter" "db_name" {
  name        = "${var.prefix}/DB_NAME"
  type        = "String"
  value       = var.db_name
}

resource "aws_ssm_parameter" "db_port" {
  name        = "${var.prefix}/DB_PORT"
  type        = "String"
  value       = tostring(var.db_port)
}

resource "aws_ssm_parameter" "db_host" {
  name        = "${var.prefix}/DB_HOST"
  type        = "String"
  value       = var.db_host
}