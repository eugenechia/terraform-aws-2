terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.0.0-beta1"
    }
  }
}

# Configure the AWS Provider
//refer to https://medium.com/@nicksanders41/setting-up-aws-profiles-for-vscode-9257a865e042
provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "homelab"
  region = "ap-southeast-1"
}