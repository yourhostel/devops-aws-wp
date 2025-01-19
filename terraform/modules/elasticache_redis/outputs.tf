# modules/elasticache_redis/outputs.tf

# Endpoint Redis
output "redis_endpoint" {
  description = "Endpoint для ElastiCache Redis"
  value       = aws_elasticache_cluster.redis.cache_nodes[0].address
}

# Порт Redis
output "redis_port" {
  description = "Порт для ElastiCache Redis"
  value       = aws_elasticache_cluster.redis.port
}

# Security Group ID
output "redis_security_group_id" {
  description = "ID Security Group для ElastiCache Redis"
  value       = aws_security_group.redis_sg.id
}
