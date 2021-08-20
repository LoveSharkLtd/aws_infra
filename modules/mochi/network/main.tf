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

module "vpc-endpoints" {
  source             = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  vpc_id             = module.vpc.vpc_id
  security_group_ids = [aws_security_group.public.id]
  endpoints = {
    ssm = {
      service             = "ssm"
      subnet_ids          = module.vpc.public_subnets
      tags                = { Name = "ssm-vpc-endpoint" }
      private_dns_enabled = true
    },
    sns = {
      service             = "sns"
      subnet_ids          = module.vpc.public_subnets
      tags                = { Name = "sns-vpc-endpoint" }
      private_dns_enabled = true
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