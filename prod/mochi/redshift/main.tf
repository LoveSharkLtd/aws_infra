provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {}

}

module "redshift" {
  source = "../../../modules/mochi/redshift"

  infra_env                = var.infra_env
  vpc_security_group_ids   = [data.terraform_remote_state.network.outputs.security_group_redshift]
  redshift_node_type       = var.redshift_node_type
  redshift_cluster_type    = var.redshift_cluster_type
  redshift_number_of_nodes = var.redshift_number_of_nodes
}


data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "terraform-prod-mochi-state"
    key    = "${var.infra_env}/mochi/network/terraform.tfstate"
    region = "eu-west-1"
  }
}

