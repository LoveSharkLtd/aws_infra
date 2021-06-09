provider "aws" {
  region  = "eu-west-1"
  
}

terraform {
  backend "s3" {}
}

module "cloudfront" {
  source = "../../modules/cloudfront"
  
}
