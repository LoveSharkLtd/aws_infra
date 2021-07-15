provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {}
}

module "iam_role" {
  source = "../../../modules/mochi/iam_role"

}