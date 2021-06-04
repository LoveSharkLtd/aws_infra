provider "aws" {
  region  = "eu-west-1"
  profile = "circleci_sandbox"
}

terraform {
  backend "s3" {
    bucket         = "terraform-mochi-state"
    key            = "dev/kinesis/terraform.tfstate"
    profile        = "circleci_sandbox"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true

  }
}

module "kinesis" {
  source = "../../modules/kinesis"

  stream_name      = var.stream_name
  telemetry_bucket_arn = data.terraform_remote_state.s3.outputs.mochi_telemetry_bucket_arn
  kinesis_shard_count = var.kinesis_shard_count
}


data "terraform_remote_state" "s3" {
  backend = "s3"
  config = {
    bucket               = "terraform-mochi-state"
    key                  = "dev/s3/terraform.tfstate"
    profile        = "circleci_sandbox"
    region         = "eu-west-1"
  }
}