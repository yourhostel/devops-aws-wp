variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "project_name" {
  description = "Unique prefix for naming"
  type        = string
  default     = "abz_project"
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {
    Environment = "test"
    Owner       = "DevOps"
  }
}
