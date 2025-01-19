# modules/elasticache_redis/variables.tf

variable "vpc_id" {
  description = "ID of the VPC where resources will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs of private subnets where Redis will be deployed"
  type        = list(string)
}

variable "ec2_security_group_id" {
  description = "ID of the Security Group for EC2 instance"
  type        = string
}

variable "project_name" {
  description = "Unique prefix for resource naming"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
}
