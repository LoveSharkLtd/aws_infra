provider "aws" {
  region = "eu-west-1"

}

provider "aws" {
  alias  = "eu-west-2"
  region = "eu-west-2"
}

terraform {
  backend "s3" {}
}

resource "aws_s3_bucket" "test_bucket" {
  bucket        = "delete-movearchive"
  provider      = aws.eu-west-2
  acl           = "private"
  force_destroy = false



  lifecycle {

    prevent_destroy = true
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket" "mochi_bucket" {
  bucket        = "loveshark-prod"
  provider      = aws.eu-west-2
  force_destroy = false

  lifecycle {

    prevent_destroy = true
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST", "PUT", ]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }
}

resource "aws_ssm_parameter" "mochi_assets_bucket" {
  name        = "mochi_assets_bucket"
  description = "mochi_assets_bucket "
  type        = "String"
  overwrite   = true
  value       = aws_s3_bucket.mochi_bucket.bucket
}


resource "aws_s3_bucket" "mochi_telemetry_bucket" {
  bucket        = "mochi-telemetry-data"
  provider      = aws.eu-west-2
  force_destroy = false
  grant {
    id          = "abcd6fea6710c0a2ecccf11af3cce02f2a8d7565571fd18ad24def693bf0aa64"
    permissions = ["READ", "READ_ACP", "WRITE", "WRITE_ACP"]
    type        = "CanonicalUser"
  }
  lifecycle {

    prevent_destroy = true
  }
}

resource "aws_ssm_parameter" "mochi_telemetry_bucket" {
  name        = "mochi_telemetry_bucket"
  description = "mochi_telemetry_bucket "
  type        = "String"
  overwrite   = true
  value       = aws_s3_bucket.mochi_telemetry_bucket.bucket
}


output "mochi_telemetry_bucket_arn" {
  value = aws_s3_bucket.mochi_telemetry_bucket.arn

}
