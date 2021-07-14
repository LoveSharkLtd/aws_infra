provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {}

}

module "redshift" {
  source = "../../../modules/mochi/redshift"

  infra_env              = var.infra_env
  vpc_security_group_ids = [data.terraform_remote_state.network.outputs.security_group_redshift]
}


data "terraform_remote_state" "s3" {
  backend = "s3"
  config = {
    bucket = "terraform-mochi-state"
    key    = "${var.infra_env}/mochi/s3/terraform.tfstate"
    region = "eu-west-1"
  }
}

