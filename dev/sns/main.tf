provider "aws" {
  region  = "eu-west-1"
  profile = "circleci_sandbox"
}

terraform {
  backend "s3" {
    bucket         = "terraform-mochi-state"
    key            = "dev/sns/terraform.tfstate"
    profile        = "circleci_sandbox"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true

  }
}

module "sns" {
  source = "../../modules/sns"
  sns_platform_application      = var.sns_platform_application
  
}
