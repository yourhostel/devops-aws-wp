# modules/ec2/variables.tf

variable "vpc_id" {
  description = "ID of the VPC where EC2 will be deployed"
  type        = string
}

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

variable "tags" {
  description = "Tags for EC2 resources"
  type        = map(string)
}

variable "project_name" {
  description = "Unique prefix for naming resources"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of Security Group IDs for the EC2 instance"
  type        = list(string)
}