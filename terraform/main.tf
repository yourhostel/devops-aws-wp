# main.tf

provider "aws" {
  region = var.region
  default_tags {
    tags = var.tags
  }
}

module "security_group" {
  source       = "./modules/security_group"
  vpc_id       = module.vpc.vpc_id
  ssh_cidr_blocks  = var.ssh_cidr_blocks # Для демонстрації залишаємо відкритий доступ
  http_cidr_blocks = var.http_cidr_blocks
  project_name = var.project_name
  tags         = var.tags
}

module "vpc" {
  source       = "./modules/vpc"
  region       = var.region
  project_name = var.project_name
  tags         = var.tags
}

module "ec2" {
  source           = "./modules/ec2"
  vpc_id           = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  instance_type    = var.instance_type
  ami_id           = var.ami_id
  key_name         = var.key_name
  vpc_security_group_ids = [module.security_group.ec2_sg_id]
  project_name     = var.project_name
  tags             = var.tags
}

# Вихідні дані Security Group
output "security_group_id" {
  description = "ID of the EC2 Security Group"
  value       = module.security_group.ec2_sg_id
}

# Вихідні дані для VPC
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

# Вихідні дані EC2
output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2.ec2_public_ip
}

output "ec2_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = module.ec2.ec2_private_ip
}

