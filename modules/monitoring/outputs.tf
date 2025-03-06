output "config_role_arn" {
  description = "ARN of the AWS Config IAM role"
  value       = aws_iam_role.config_role.arn
}

output "eks_log_group_name" {
  description = "Name of the EKS CloudWatch log group"
  value       = aws_cloudwatch_log_group.eks.name
}

output "alb_log_group_name" {
  description = "Name of the ALB CloudWatch log group"
  value       = aws_cloudwatch_log_group.alb.name
}

output "rds_log_group_name" {
  description = "Name of the RDS CloudWatch log group"
  value       = aws_cloudwatch_log_group.rds.name
} 