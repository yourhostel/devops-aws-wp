variable "region" {
  description = "AWS region for VPC"
  type        = string
}

variable "project_name" {
  description = "Unique prefix for resource naming"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
}