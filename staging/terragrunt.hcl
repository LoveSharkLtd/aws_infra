
remote_state {
  backend = "s3"
  config = {
    bucket         = "terraform-staging-mochi-state"
    key            = "staging/${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }
}