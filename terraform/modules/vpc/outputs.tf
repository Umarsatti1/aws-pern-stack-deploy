output "vpc_id" {
    value       = module.vpc.vpc_id
    description = "ID of the VPC"
}

output "public_subnets" {
    value       = module.vpc.public_subnets
    description = "List of public subnet IDs"
}

output "private_subnets" {
    value       = module.vpc.private_subnets
    description = "List of private subnet IDs"
}