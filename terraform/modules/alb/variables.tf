variable "name" {
  description = "Name prefix for the ALB"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnets"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to ALB"
  type        = list(string)
}

variable "target_port" {
  description = "Port where the ECS app listens (e.g. 3000)"
  type        = number
}

variable "app_name" {
  description = "App prefix for naming"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ALB and target group"
  type        = string
}