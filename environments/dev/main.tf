provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../../modules/vpc"

  environment       = var.environment
  vpc_cidr         = var.vpc_cidr
  azs              = var.azs
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  database_subnets = var.database_subnets
  tags             = var.tags
}

module "eks" {
  source = "../../modules/eks"

  cluster_name       = "${var.environment}-${var.cluster_name}"
  cluster_version    = var.cluster_version
  vpc_id            = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets
  instance_types     = var.instance_types
  tags              = var.tags
}

module "database" {
  source = "../../modules/database"

  environment         = var.environment
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = module.vpc.vpc_cidr_block
  database_subnet_ids = module.vpc.database_subnets
  db_instance_class   = var.db_instance_class
  redis_node_type     = var.redis_node_type
  tags               = var.tags
}

module "alb" {
  source = "../../modules/alb"

  environment        = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnets
  certificate_arn   = var.certificate_arn
  access_logs_bucket = module.s3_logs.s3_bucket_id
  tags              = var.tags
}

module "s3_logs" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket = "${var.environment}-alb-logs"
  acl    = "private"

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule = [
    {
      id      = "log"
      enabled = true

      transition = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        },
        {
          days          = 60
          storage_class = "GLACIER"
        }
      ]

      expiration = {
        days = 90
      }
    }
  ]

  tags = var.tags
}

module "monitoring" {
  source = "../../modules/monitoring"

  environment     = var.environment
  cluster_name    = module.eks.cluster_id
  alb_arn_suffix  = module.alb.arn_suffix
  rds_cluster_id  = module.database.aurora_cluster_endpoint
  sns_topic_arn   = aws_sns_topic.alerts.arn
  tags            = var.tags
}

resource "aws_sns_topic" "alerts" {
  name = "${var.environment}-alerts"
  tags = var.tags
}

resource "aws_sns_topic_subscription" "alerts_email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
} 