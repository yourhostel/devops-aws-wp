# modules/rds_mysql/outputs.tf

output "rds_sg_id" {
  description = "ID of the Security Group for RDS"
  value       = aws_security_group.rds_sg.id
}

output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.main.endpoint
}

output "rds_port" {
  description = "Port of the RDS instance"
  value       = aws_db_instance.main.port
}

output "rds_instance_id" {
  description = "ID of the RDS instance"
  value       = aws_db_instance.main.id
}

output "rds_tags" {
  description = "Tags applied to RDS instance"
  value       = aws_db_instance.main.tags
}