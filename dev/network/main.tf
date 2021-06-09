provider "aws" {
  region = "eu-west-1"

}

terraform {
  backend "s3" {}
}

module "vpc" {
  source = "../../modules/network"

  infra_env      = var.infra_env
  vpc_cidr       = "10.0.0.0/17"
  azs            = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  public_subnets = slice(cidrsubnets("10.0.0.0/17", 4, 4, 4, 4, 4, 4), 0, 3)

}





