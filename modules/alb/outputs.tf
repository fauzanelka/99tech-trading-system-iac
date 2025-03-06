output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.alb.lb_dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the ALB"
  value       = module.alb.lb_zone_id
}

output "target_group_arns" {
  description = "ARNs of the target groups"
  value       = module.alb.target_group_arns
}

output "https_listener_arns" {
  description = "ARNs of the HTTPS listeners"
  value       = module.alb.https_listener_arns
}

output "security_group_id" {
  description = "Security group ID of the ALB"
  value       = aws_security_group.alb.id
}

output "arn_suffix" {
  description = "ARN suffix of the ALB"
  value       = module.alb.lb_arn_suffix
} 