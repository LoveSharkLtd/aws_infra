provider "aws" {
  region  = "eu-west-1"
  profile = var.aws_profile
}

terraform {
  backend "s3" {
    bucket         = "terraform-mochi-state"
    key            = "dev/database/terraform.tfstate"
    profile        = "circleci_sandbox"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true

  }
}

module "database" {
  source = "../../modules/database"

  infra_env      = var.infra_env
  azs =  data.terraform_remote_state.network.outputs.vpc_azs
  mysql_master_username = var.mysql_master_username
  mysql_master_password =var.mysql_master_password
  vpc_security_group_ids  = [data.terraform_remote_state.network.outputs.security_group_mysql_id]
  subnet_ids = data.terraform_remote_state.network.outputs.vpc_public_subnets
  mysql_instance_class = var.mysql_instance_class
}


data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket               = "terraform-mochi-state"
    key                  = "dev/network/terraform.tfstate"
    profile        = "circleci_sandbox"
    region         = "eu-west-1"
  }
}

