provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {}

}

module "cognito" {
  source                   = "../../../modules/mochi/cognito"
  infra_env                = var.infra_env
  sms_monthly_dollar_limit = var.sms_monthly_dollar_limit
}



