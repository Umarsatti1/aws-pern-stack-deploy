variable "name" {
  description = "Name prefix for the RDS instance"
  type        = string
}

variable "db_name" {
  description = "The name of the database to create"
  type        = string
}

variable "db_username" {
  description = "The username for the database"
  type        = string
}

variable "db_password" {
  description = "The password for the database"
  type        = string
}

variable "db_port" {
  type        = number
  default     = 5432
  description = "PostgreSQL port number"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs to deploy RDS into"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "CIDRs allowed to connect to RDS"
}

variable "rds_sg_id" {
  type = string
}