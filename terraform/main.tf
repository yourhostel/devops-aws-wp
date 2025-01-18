provider "aws" {
  region = var.region
}

module "vpc" {
  source      = "./modules/vpc"
  region      = var.region
  project_name = var.project_name
  tags        = var.tags
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = module.vpc.private_subnet_ids
}
