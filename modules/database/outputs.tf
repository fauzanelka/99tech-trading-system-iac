output "aurora_cluster_endpoint" {
  description = "Writer endpoint for the Aurora cluster"
  value       = module.aurora_postgresql.cluster_endpoint
}

output "aurora_cluster_reader_endpoint" {
  description = "Reader endpoint for the Aurora cluster"
  value       = module.aurora_postgresql.cluster_reader_endpoint
}

output "aurora_cluster_port" {
  description = "Port of the Aurora cluster"
  value       = module.aurora_postgresql.cluster_port
}

output "redis_endpoint" {
  description = "Redis primary endpoint"
  value       = module.redis.replication_group_primary_endpoint_address
}

output "aurora_security_group_id" {
  description = "Security group ID for Aurora PostgreSQL"
  value       = module.aurora_postgresql.security_group_id
}

output "redis_security_group_id" {
  description = "Security group ID for Redis"
  value       = aws_security_group.redis.id
} 