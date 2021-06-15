provider "aws" {
  region = "eu-west-1"

}

terraform {
  backend "s3" {}
}

module "sns" {
  source                   = "../../modules/sns"
  sns_platform_application = var.sns_platform_application

}
