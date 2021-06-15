module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name = "mochi-${var.infra_env}-vpc"

  cidr = var.vpc_cidr
  azs  = var.azs

  public_subnets = var.public_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true
}


# module "redshift-sg" {
#   source = "terraform-aws-modules/security-group/aws//modules/redshift"

#   name        = "mochi-${var.infra_env}-redshift-sg"
#   description = "Security group for redshift w"
#   vpc_id      = module.vpc.vpc_id

#   ingress_cidr_blocks = [module.vpc.vpc_cidr_block,"18.130.1.96/27"]
#   ingress_with_self =[]
# }

module "vpc-endpoints" {
  source             = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  vpc_id             = module.vpc.vpc_id
  security_group_ids = [aws_security_group.public.id]
  endpoints = {
    ssm = {
      service            = "ssm"
      security_group_ids = [aws_security_group.public.id]
      subnet_ids         = module.vpc.public_subnets
      tags               = { Name = "ssm-vpc-endpoint" }

    },
    s3 = {
      service    = "s3"
      subnet_ids = module.vpc.public_subnets
      tags       = { Name = "s3-vpc-endpoint" }
    },
    s3_gateway = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = flatten([module.vpc.intra_route_table_ids, module.vpc.public_route_table_ids])
      tags            = { Name = "s3-vpc-gateway-endpoint" }
    },
    logs = {
      service             = "logs"
      subnet_ids          = module.vpc.public_subnets
      private_dns_enabled = true
      tags                = { Name = "logs-vpc-endpoint" }

    },
    ecr_api = {
      service             = "ecr.api"
      subnet_ids          = module.vpc.public_subnets
      private_dns_enabled = true
      tags                = { Name = "ecr_api-vpc-endpoint" }

    },
    ecr_dkr = {
      service             = "ecr.dkr"
      private_dns_enabled = true
      subnet_ids          = module.vpc.public_subnets
      tags                = { Name = "ecr_dkr-vpc-endpoint" }

    },


  }
  tags = {
    Environment = var.infra_env
  }
}


resource "aws_ssm_parameter" "subnet_ids" {
  name        = "subnet_ids"
  description = "subnet_ids of vpc"
  type        = "StringList"
  value       = join(",", module.vpc.public_subnets)
}