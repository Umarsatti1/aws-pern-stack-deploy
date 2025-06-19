variable "project" {
  type        = string
  description = "Prefix for SG names"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for security groups"
}

variable "rds_port" {
  type        = number
  description = "Port number for PostgreSQL access"
}