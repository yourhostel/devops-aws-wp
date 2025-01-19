# modules/rds_mysql/variables.tf

variable "project_name" {
  description = "Unique prefix for naming resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where RDS will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for RDS"
  type        = list(string)
}

variable "db_name" {
  description = "Name of the RDS database"
  type        = string
}

variable "db_user" {
  description = "Username for the RDS database"
  type        = string
}

variable "db_password" {
  description = "Password for the RDS database"
  type        = string
}

variable "db_instance_class" {
  description = "Instance class for RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "tags" {
  description = "Tags for the RDS resources"
  type        = map(string)
}

variable "ec2_security_group_id" {
  description = "ID of the EC2 Security Group to allow access to RDS"
  type        = string
}