variable "app_name" {
  description = "Application name"
  type        = string
}

variable "cluster_name" {
  description = "Name of ECS cluster"
  type        = string
}

variable "server_image" {
  description = "Docker image for backend"
  type        = string
}

variable "execution_role_arn" {
  description = "IAM role ARN for ECS task execution"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "service_sg_id" {
  description = "Security group ID for ECS service"
  type        = string
}

variable "ecs_sg_id" {
  type = string
}

variable "target_group_arn" {
  description = "Target group ARN for ALB"
  type        = string
}

variable "client_image" {
  description = "Docker image for frontend"
  type        = string
}