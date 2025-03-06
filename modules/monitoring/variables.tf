variable "environment" {
  description = "Environment name"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "alb_arn_suffix" {
  description = "ARN suffix of the ALB"
  type        = string
}

variable "rds_cluster_id" {
  description = "ID of the RDS cluster"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic for CloudWatch alarms"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
} 