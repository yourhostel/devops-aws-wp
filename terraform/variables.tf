# variables.tf

variable "ssh_cidr_blocks" {
  description = "Allowed CIDR blocks for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Відкриває доступ для всіх IP-адрес (Небажано у продакшені, краще обмежити доступ
                              # по SSH конкретними IP-адресами (наприклад
                              # ssh_cidr_blocks = ["<office-ip>/32"].)
}

variable "http_cidr_blocks" {
  description = "Allowed CIDR blocks for HTTP access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Unique prefix for naming"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {
    Environment = "test"
    Owner       = "DevOps"
  }
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
  description = "SSH key pair name"
  type        = string
}