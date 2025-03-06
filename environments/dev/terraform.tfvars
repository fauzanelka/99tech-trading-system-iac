aws_region = "ap-southeast-1"
environment = "dev"

vpc_cidr = "10.0.0.0/16"
azs = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
database_subnets = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24"]

cluster_name = "99tech-trading-system"
cluster_version = "1.28"
instance_types = ["t3.medium"]

db_instance_class = "db.r6g.large"
redis_node_type = "cache.r6g.large"

# Replace these values with your own
certificate_arn = "arn:aws:acm:ap-southeast-1:123456789012:certificate/example"
alert_email = "alerts@example.com"

tags = {
  Environment = "dev"
  Project     = "99tech-trading-system"
  Terraform   = "true"
  Owner       = "DevOps Team"
} 