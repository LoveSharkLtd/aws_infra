provider "aws" {
  region  = "eu-west-1"
  profile = "circleci_sandbox"
}

terraform {
  backend "s3" {
    bucket         = "terraform-mochi-state"
    key            = "dev/terraform.tfstate"
    profile        = "circleci_sandbox"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true

  }
  # backend "s3" {
  #   bucket = "terraform-mochi-state"
  #   key = "dev/terraform.tfstate"
  #   profile = "circleci_sandbox"
  #   region = "eu-west-1"
  #   encrypt = "true"
  #   # ...
  # }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-mochi-state"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}


resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"

  }


}