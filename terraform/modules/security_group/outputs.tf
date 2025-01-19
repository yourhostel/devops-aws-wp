# modules/security_group/outputs.tf

output "ec2_sg_id" {
  description = "ID of the EC2 Security Group"
  value       = aws_security_group.ec2_sg.id
}