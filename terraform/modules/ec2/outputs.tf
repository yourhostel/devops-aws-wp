# modules/ec2/outputs.tf

output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.main.public_ip
}

output "ec2_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.main.private_ip
}

output "ec2_sg_id" {
  description = "ID of the EC2 Security Group"
  value       = aws_security_group.ec2_sg.id
}