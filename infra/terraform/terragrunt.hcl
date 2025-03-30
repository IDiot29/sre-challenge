remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "nimbly-test-state"
    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "nimbly-test-table"
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  required_providers {
      aws = {
      source  = "hashicorp/aws"
      version = ">= 5.16.0, < 5.74.0"
      }
  }
}
provider "aws" {
alias   = "nimbly"
region  = "ap-southeast-3"
}
EOF
}

generate "locals" {
  path      = "locals.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
locals {
  nimbly-tags = {
    Terraform    = "true"
    Organization = "bibit"
    Owner        = "rivaldo"
  }
}
  EOF
}
