# modules/ec2/main.tf

# Security Group
resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.project_name}-ec2-sg"
  })
}

# Вихідне правило (Egress): Дозволяє всі вихідні з'єднання для інтернету і RDS
resource "aws_security_group_rule" "ec2_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"          # Дозволяє всі протоколи
  security_group_id = aws_security_group.ec2_sg.id
  cidr_blocks       = ["0.0.0.0/0"] # Дозволяє доступ до всіх адрес
}

# Вхідне правило для SSH
resource "aws_security_group_rule" "ec2_ingress_ssh" {
  type              = "ingress"
  from_port         = 22              # Порт SSH
  to_port           = 22
  protocol          = "tcp"           # Протокол TCP
  security_group_id = aws_security_group.ec2_sg.id
  cidr_blocks       = var.ssh_cidr_blocks # Дозволяємо доступ з указаних CIDR
}

# Вхідне правило для HTTP
resource "aws_security_group_rule" "ec2_ingress_http" {
  type              = "ingress"
  from_port         = 80              # Порт HTTP
  to_port           = 80
  protocol          = "tcp"           # Протокол TCP
  security_group_id = aws_security_group.ec2_sg.id
  cidr_blocks       = var.http_cidr_blocks # Дозволяємо доступ з указаних CIDR
}


# EC2
resource "aws_instance" "main" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_ids[0] # Використовуємо першу публічну мережу
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = merge(var.tags, {
    Name = "${var.project_name}-ec2"
  })
}
