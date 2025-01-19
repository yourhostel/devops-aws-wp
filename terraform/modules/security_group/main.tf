# modules/security_group/main.tf

resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id

  # Вхідні правила (Ingress)
  ingress {
    from_port   = 22             # Дозволяє підключення через порт 22 (SSH)
    to_port     = 22             # Діапазон: від 22 до 22
    protocol    = "tcp"          # Використовується протокол TCP
    cidr_blocks = var.ssh_cidr_blocks # Динамічний список CIDR для SSH
  }

  ingress {
    from_port   = 80             # Дозволяє підключення через порт 80 (HTTP)
    to_port     = 80             # Діапазон: від 80 до 80
    protocol    = "tcp"          # Використовується протокол TCP
    cidr_blocks = var.http_cidr_blocks # Динамічний список CIDR для HTTP
  }

  # Вихідні правила (Egress)
  egress {
    from_port   = 0              # Дозволяє всі вихідні з'єднання (з будь-якого порту)
    to_port     = 0              # Дозволяє з'єднання на будь-який порт
    protocol    = "-1"           # Дозволяє всі протоколи (TCP, UDP тощо)
    cidr_blocks = ["0.0.0.0/0"]  # Дозволяє вихідні з'єднання для всіх IP-адрес
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-ec2-sg"
  })
}
