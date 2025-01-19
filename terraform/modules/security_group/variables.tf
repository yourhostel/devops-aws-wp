# modules/security_group/variables.tf

variable "vpc_id" {
  description = "ID of the VPC where Security Group will be created"
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

variable "tags" {
  description = "Tags for Security Group"
  type        = map(string)
}

variable "project_name" {
  description = "Unique prefix for naming resources"
  type        = string
}
