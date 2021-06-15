provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {}

}

module "cognito-idp" {
  source    = "../../modules/cognito-idp"
  infra_env = var.infra_env

}