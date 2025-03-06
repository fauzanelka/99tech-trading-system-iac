module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name                   = var.cluster_name
  cluster_version               = var.cluster_version
  cluster_endpoint_public_access = false

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  eks_managed_node_groups = {
    default = {
      min_size     = 2
      max_size     = 10
      desired_size = 3

      instance_types = var.instance_types
      capacity_type  = "ON_DEMAND"

      update_config = {
        max_unavailable_percentage = 33
      }
    }
  }

  # Enable IRSA
  enable_irsa = true

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
  }

  tags = var.tags
} 