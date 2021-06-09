
remote_state {
  backend = "s3"
  config = {
    bucket         = "terraform-mochi-state"
    key            = "dev/${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }
}