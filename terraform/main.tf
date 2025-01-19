# main.tf

provider "aws" {
  region = var.region
  default_tags {
    tags = var.tags
  }
}

module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  tags         = var.tags
}

module "ec2" {
  source           = "./modules/ec2"
  vpc_id           = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  private_subnet_cidr_blocks = module.vpc.private_subnet_cidr_blocks
  instance_type    = var.instance_type
  ami_id           = var.ami_id
  key_name         = var.key_name
  project_name     = var.project_name
  tags             = var.tags
}

module "rds_mysql" {
  source              = "./modules/rds_mysql"
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  ec2_security_group_id = module.ec2.ec2_sg_id
  db_name             = var.db_name
  db_user             = var.db_user
  db_password         = var.db_password
  db_instance_class   = var.db_instance_class
  tags                = var.tags
  project_name        = var.project_name
}

module "elasticache_redis" {
  source              = "./modules/elasticache_redis"
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  ec2_security_group_id = module.ec2.ec2_sg_id
  project_name        = var.project_name
  tags                = var.tags
}

# Вихідні дані для VPC
output "vpc_info" {
  description = "Details about the created VPC"
  value = {
    vpc_id                   = module.vpc.vpc_id
    public_subnet_ids        = module.vpc.public_subnet_ids
    private_subnet_ids       = module.vpc.private_subnet_ids
    private_subnet_cidr_blocks = module.vpc.private_subnet_cidr_blocks
  }
}

# Вихідні дані для EC2
output "ec2_info" {
  description = "Details about the EC2 instance"
  value = {
    public_ip           = module.ec2.ec2_public_ip
    private_ip          = module.ec2.ec2_private_ip
    security_group_id   = module.ec2.ec2_sg_id
  }
}

# Вихідні дані для Redis
output "redis_info" {
  description = "Details about the Redis instance"
  value = {
    endpoint          = module.elasticache_redis.redis_endpoint
    port              = module.elasticache_redis.redis_port
    security_group_id = module.elasticache_redis.redis_security_group_id
  }
}

# Вихідні дані для RDS
output "rds_info" {
  description = "Details about the RDS instance"
  value = {
    endpoint            = module.rds_mysql.rds_endpoint
    port                = module.rds_mysql.rds_port
    security_group_id   = module.rds_mysql.rds_sg_id
    instance_id         = module.rds_mysql.rds_instance_id
    tags                = module.rds_mysql.rds_tags
  }
}
