provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {}

}

module "cognito" {
  source    = "../../../modules/cms/cognito"
  infra_env = var.infra_env

}



