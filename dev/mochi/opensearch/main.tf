provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {}
}

module "opensearch" {
  source = "../../../modules/mochi/opensearch"

  infra_env                = var.infra_env
  azs                      = data.terraform_remote_state.network.outputs.vpc_azs
  public_subnets           = data.terraform_remote_state.network.outputs.vpc_public_subnets
  vpc_security_group_ids   = [data.terraform_remote_state.network.outputs.security_group_public]
  opensearch_instance_type = var.opensearch_instance_type
  opensearch_domain_name   = var.opensearch_domain_name
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "terraform-mochi-state"
    key    = "${var.infra_env}/mochi/network/terraform.tfstate"
    region = "eu-west-1"
  }
}
