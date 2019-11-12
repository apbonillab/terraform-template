provider "aws" {
  region  = "us-east-1"
}

terraform {
  required_version = ">= 0.12, < 0.13"
  backend "s3" {
    region         = "us-east-1"
    bucket         = "state-staging"
    key            = "staging-main/terraform.tfstate"
    
  }
}
module "api_gateway" {
  source                                           = "../api_gw/api_gw_init"
  api_gateway_name                                 = "internal_test"
}
