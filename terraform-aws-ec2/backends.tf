terraform {
  backend "local" {
    path = "/terraform-aws-ec2/state/terraform.tfstate"
  }
}