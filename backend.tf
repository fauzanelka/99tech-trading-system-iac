terraform {
  backend "s3" {
    bucket         = "99tech-trading-system-terraform-state"
    key            = "terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "99tech-trading-system-terraform-lock"
  }
}

# Create S3 bucket for Terraform state
module "terraform_state_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket = "99tech-trading-system-terraform-state"
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

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  tags = {
    Name = "99tech-trading-system-terraform-state"
  }
}

# Create DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_lock" {
  name           = "99tech-trading-system-terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "99tech-trading-system-terraform-lock"
  }
}
