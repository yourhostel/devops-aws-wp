# modules/ec2/main.tf

# EC2 інстанс
resource "aws_instance" "main" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_ids[0] # Використовуємо першу публічну мережу
  key_name      = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids

  tags = merge(var.tags, {
    Name = "${var.project_name}-ec2"
  })
}
