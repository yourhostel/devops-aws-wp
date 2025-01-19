# modules/ec2/variables.tf

variable "project_name" {
  description = "Unique prefix for naming resources"
  type        = string
}

variable "tags" {
  description = "Tags for Security Group"
  type        = map(string)
}

# EC2
variable "public_subnet_ids" {
  description = "List of public subnet IDs for EC2"
  type        = list(string)
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "Amazon Machine Image ID"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

# SG
variable "vpc_id" {
  description = "ID of the VPC where EC2 will be deployed"
  type        = string
}

variable "ssh_cidr_blocks" {
  description = "Allowed CIDR blocks for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "http_cidr_blocks" {
  description = "Allowed CIDR blocks for HTTP access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks of private subnets for RDS access"
  type        = list(string)
}
