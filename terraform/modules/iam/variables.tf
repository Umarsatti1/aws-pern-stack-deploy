variable "role_name" {
  description = "Name for IAM role"
  type        = string
}

variable "ssm_prefix" {
  description = "Prefix of SSM parameter path (e.g. /pern)"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}