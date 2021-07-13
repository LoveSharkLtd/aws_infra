provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {}

}

module "database" {
  source = "../../../modules/mochi/database"

  infra_env              = var.infra_env
  azs                    = data.terraform_remote_state.network.outputs.vpc_azs
  vpc_security_group_ids = [data.terraform_remote_state.network.outputs.security_group_mysql_id]
  subnet_ids             = data.terraform_remote_state.network.outputs.vpc_public_subnets
  mysql_instance_class   = var.mysql_instance_class
}


data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "terraform-staging-mochi-state"
    key    = "${var.infra_env}/mochi/network/terraform.tfstate"
    region = "eu-west-1"
  }
}


