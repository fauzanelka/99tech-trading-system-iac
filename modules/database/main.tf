module "aurora_postgresql" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 8.0"

  name           = "${var.environment}-aurora-postgresql"
  engine         = "aurora-postgresql"
  engine_version = "15.3"
  instance_class = var.db_instance_class

  instances = {
    1 = {
      instance_class = var.db_instance_class
    }
    2 = {
      instance_class = var.db_instance_class
    }
  }

  vpc_id               = var.vpc_id
  db_subnet_group_name = aws_db_subnet_group.this.name
  security_group_rules = {
    ingress = {
      cidr_blocks = [var.vpc_cidr]
    }
  }
  
  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = 10

  backup_retention_period = 7
  preferred_backup_window = "02:00-03:00"

  enabled_cloudwatch_logs_exports = ["postgresql"]

  tags = var.tags
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.environment}-aurora-subnet-group"
  subnet_ids = var.database_subnet_ids

  tags = var.tags
}

module "redis" {
  source  = "terraform-aws-modules/elasticache/aws"
  version = "~> 1.4.1"

  replication_group_id = "${var.environment}-redis"
  cluster_id           = "${var.environment}-redis"
  engine              = "redis"
  engine_version      = "7.0"
  node_type           = var.redis_node_type
  num_cache_nodes     = 2
  port                = 6379

  subnet_group_name = aws_elasticache_subnet_group.this.name
  security_group_ids = [aws_security_group.redis.id]

  at_rest_encryption_enabled = true
  transit_encryption_enabled = true

  apply_immediately = true
  auto_minor_version_upgrade = true

  tags = var.tags
}

resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.environment}-redis-subnet-group"
  subnet_ids = var.database_subnet_ids

  tags = var.tags
}

resource "aws_security_group" "redis" {
  name_prefix = "${var.environment}-redis-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = var.tags
} 