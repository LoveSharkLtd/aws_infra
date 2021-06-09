resource "aws_elasticache_replication_group" "mochi_redis" {

  automatic_failover_enabled    = true
  multi_az_enabled              = true
  availability_zones            = [var.azs[0], var.azs[1]]
  replication_group_id          = "mochi-${var.infra_env}-rediscache"
  security_group_ids            = var.vpc_security_group_ids
  subnet_group_name             = aws_elasticache_subnet_group.mochi-redis-subnet.name
  replication_group_description = "redis cache description"
  node_type                     = var.redis_node_type
  number_cache_clusters         = var.redis_nodes
  parameter_group_name          = "default.redis6.x"
  port                          = 6379
  engine_version                = "6.x"
  engine                        = "redis"

  lifecycle {
    ignore_changes = [number_cache_clusters]
  }

  tags = {
    Name        = "my_sql_cluster replication group"
    ManagedBy   = "terraform"
    Environment = var.infra_env
  }

}

resource "aws_elasticache_cluster" "replica" {
  count = 0

  cluster_id           = "mochi-${var.infra_env}-rediscache-${count.index}"
  replication_group_id = aws_elasticache_replication_group.mochi_redis.id
}

resource "aws_elasticache_subnet_group" "mochi-redis-subnet" {
  name       = "mochi-redis-${var.infra_env}-subnet"
  subnet_ids = var.public_subnets
}



resource "aws_ssm_parameter" "redis_primary_endpoint" {
  name        = "redis_primary_endpoint"
  description = "redis_primary_endpoint "
  type        = "String"
  value       = aws_elasticache_replication_group.mochi_redis.primary_endpoint_address
}

resource "aws_ssm_parameter" "redis_reader_endpoint" {
  name        = "redis_reader_endpoint"
  description = "redis_reader_endpoint "
  type        = "String"
  value       = aws_elasticache_replication_group.mochi_redis.reader_endpoint_address
}

resource "aws_ssm_parameter" "redis_port" {
  name        = "redis_port"
  description = "redis_port "
  type        = "String"
  value       = aws_elasticache_replication_group.mochi_redis.port
}