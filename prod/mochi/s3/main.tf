provider "aws" {
  region = "eu-west-1"

}

terraform {
  backend "s3" {}
}

module "s3" {
  source    = "../../../modules/mochi/s3"
  infra_env = var.infra_env

}