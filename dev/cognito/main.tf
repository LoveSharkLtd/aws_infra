provider "aws" {
  region  = "eu-west-1"
  profile = var.aws_profile
}

terraform {
  backend "s3" {
    bucket         = "terraform-mochi-state"
    key            = "dev/cognito/terraform.tfstate"
    profile        = "circleci_sandbox"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true

  }
}

module "cognito" {
  source = "../../modules/cognito"

  infra_env      = var.infra_env
  
}



