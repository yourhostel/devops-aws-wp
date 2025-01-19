# modules/elasticache_redis/main.tf

# Створення Security Group для ElastiCache
resource "aws_security_group" "redis_sg" {
  vpc_id = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.project_name}-redis-sg"
  })
}

# Вхідне правило для ElastiCache (доступ лише з EC2)
resource "aws_security_group_rule" "redis_ingress_from_ec2" {
  type                     = "ingress"
  from_port                = 6379       # Порт для Redis
  to_port                  = 6379
  protocol                 = "tcp"      # Протокол TCP
  security_group_id        = aws_security_group.redis_sg.id
  source_security_group_id = var.ec2_security_group_id # Дозволяємо доступ лише з EC2
}

# Вихідне правило (Egress): Дозволяємо всі вихідні з'єднання
resource "aws_security_group_rule" "redis_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"          # Дозволяємо всі протоколи
  security_group_id = aws_security_group.redis_sg.id
  cidr_blocks       = ["0.0.0.0/0"] # Дозволяємо всі вихідні з'єднання
}

# Створення кластеру ElastiCache-Redis
resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "${var.project_name}-redis-cluster"
  engine               = "redis"                   # Використовуємо Redis
  engine_version       = "7.0"
  node_type            = "cache.t3.micro"          # Мінімальний тип для демонстрації
  num_cache_nodes      = 1                         # Один вузол
  parameter_group_name = "default.redis7"          # Використовуємо параметр сімейства Redis 7
  subnet_group_name    = aws_elasticache_subnet_group.main.name
  security_group_ids   = [aws_security_group.redis_sg.id]

  tags = merge(var.tags, {
    Name = "${var.project_name}-redis"
  })
}

# Група підмереж для ElastiCache
resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.project_name}-redis-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = merge(var.tags, {
    Resource = "Redis Subnet Group"
  })
}
