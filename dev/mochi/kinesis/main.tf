provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {}

}

module "kinesis" {
  source = "../../../modules/mochi/kinesis"

  stream_name          = var.stream_name
  telemetry_bucket_arn = data.terraform_remote_state.s3.outputs.mochi_telemetry_bucket_arn
  kinesis_shard_count  = var.kinesis_shard_count
}


data "terraform_remote_state" "s3" {
  backend = "s3"
  config = {
    bucket = "terraform-mochi-state"
    key    = "${var.infra_env}/mochi/s3/terraform.tfstate"
    region = "eu-west-1"

  }
}