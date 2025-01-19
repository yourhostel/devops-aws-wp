# modules/rds_mysql/main.tf

# Security Group
resource "aws_security_group" "rds_sg" {
  vpc_id = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.project_name}-rds-sg"
  })
}

# Вхідне правило (Ingress): Доступ до MySQL від EC2
resource "aws_security_group_rule" "rds_ingress_from_ec2" {
  type                     = "ingress"
  from_port                = 3306       # Порт MySQL
  to_port                  = 3306
  protocol                 = "tcp"      # TCP для MySQL
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = var.ec2_security_group_id # Дозволяємо доступ тільки від EC2
}

# Вихідне правило (Egress): Дозволяємо всі вихідні з'єднання
resource "aws_security_group_rule" "rds_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"          # Дозволяє всі протоколи
  security_group_id = aws_security_group.rds_sg.id
  cidr_blocks       = ["0.0.0.0/0"] # Дозволяє всі вихідні з'єднання
}

# RDS Instance
resource "aws_db_instance" "main" {
  allocated_storage    = 5                      # Розмір у ГБ
  engine               = "mysql"                # Використовуємо MySQL
  engine_version       = "8.0"                  # Версія MySQL
  instance_class       = var.db_instance_class  # Тип інстансу
  db_name              = var.db_name            # Ім'я бази даних
  username             = var.db_user            # Ім'я користувача
  password             = var.db_password        # Пароль користувача
  db_subnet_group_name = aws_db_subnet_group.main.name
  multi_az             = false                  # Тестове середовище, без Multi-AZ
  publicly_accessible  = false                  # Доступ тільки з VPC
  skip_final_snapshot  = true                   # Відключаємо знімок при видаленні
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = var.tags
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-rds-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = merge(var.tags, {
    Resource = "RDS Subnet Group"
  })
}
