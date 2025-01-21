# modules/iam/variables.tf

# Префікс для іменування ресурсів
variable "project_name" {
  description = "Unique prefix for project resources"
  type        = string
}

# Теги для ресурсів
variable "tags" {
  description = "Tags for project resources"
  type        = map(string)
}
