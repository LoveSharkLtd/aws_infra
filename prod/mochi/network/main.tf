provider "aws" {
  region = "eu-west-1"

}

terraform {
  backend "s3" {}
}

module "vpc" {
  source = "../../../modules/mochi/network"

  infra_env      = var.infra_env
  vpc_cidr       = "10.0.0.0/17"
  azs            = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  public_subnets = slice(cidrsubnets("10.0.0.0/17", 4, 4, 4, 4, 4, 4), 0, 3)

}

resource "aws_security_group" "redshift" {
  name        = "mochi-${var.infra_env}-redshift_sg"
  description = "security group for redshift"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name        = "mochi-${var.infra_env}-redshift_sg"
    Environment = var.infra_env
    ManagedBy   = "terraform"
  }
}

resource "aws_security_group_rule" "redshift_vpc_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.redshift.id
  description       = "VPC General"

  from_port   = 5439
  to_port     = 5439
  protocol    = "tcp"
  cidr_blocks = [module.vpc.vpc_cidr]
}

resource "aws_security_group_rule" "redshift_looker_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.redshift.id
  description       = "Looker whitelist"

  from_port = 5439
  to_port   = 5439
  protocol  = "tcp"
  cidr_blocks = [
    "52.210.85.110/32",
    "52.30.198.163/32",
    "34.249.159.112/32",
    "52.19.248.176/32",
    "54.220.245.171/32"
  ]
}

resource "aws_ssm_parameter" "redshift_security_group" {
  name        = "redshift_security_group"
  description = "redshift security group id"
  type        = "StringList"
  value       = aws_security_group.redshift.id
}

