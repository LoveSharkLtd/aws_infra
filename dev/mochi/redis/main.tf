provider "aws" {
  region = "eu-west-1"

}

terraform {
  backend "s3" {}
}

module "redis" {
  source = "../../../modules/mochi/redis"

  infra_env              = var.infra_env
  azs                    = data.terraform_remote_state.network.outputs.vpc_azs
  public_subnets         = data.terraform_remote_state.network.outputs.vpc_public_subnets
  vpc_security_group_ids = [data.terraform_remote_state.network.outputs.security_group_public]
  redis_node_type        = var.redis_node_type
  redis_nodes            = var.redis_nodes
}


data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "terraform-mochi-state"
    key    = "${var.infra_env}/mochi/network/terraform.tfstate"
    region = "eu-west-1"
  }
}