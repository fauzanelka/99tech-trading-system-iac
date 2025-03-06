module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "${var.environment}-alb"

  load_balancer_type = "application"
  internal           = false

  vpc_id          = var.vpc_id
  subnets         = var.public_subnet_ids
  security_groups = [aws_security_group.alb.id]

  access_logs = {
    bucket = var.access_logs_bucket
  }

  target_groups = [
    {
      name_prefix      = "def-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "ip"
      health_check = {
        enabled             = true
        interval           = 30
        path               = "/health"
        port               = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout            = 6
        protocol           = "HTTP"
        matcher            = "200-399"
      }
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol          = "HTTPS"
      certificate_arn    = var.certificate_arn
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  tags = var.tags
}

resource "aws_security_group" "alb" {
  name_prefix = "${var.environment}-alb-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
} 