data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket         = "nimbly-test-state"
    dynamodb_table = "nimbly-test-table"
    encrypt        = true
    key            = "VPC/terraform.tfstate"
    region         = "us-east-1"
  }
}
