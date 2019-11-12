provider "aws" {
  region = "us-east-1"
  profile = "staging"
}

terraform {
  required_version = ">= 0.12, < 0.13"
  backend "s3" {
    bucket         = "gnb-mgmt-terraform-state-stg"
    key            = "staging-main/api_gw/reporting/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "gnb-mgmt-terraform-locks-stg"
    encrypt        = true
    profile = "staging"
  }
}

// remote_state

data "terraform_remote_state" "staging" {
  backend = "s3"

  config = {
    bucket         = "gnb-mgmt-terraform-state-stg"
    key            = "staging-main/terraform.tfstate"
    region         = "us-east-1"
  }
}
// Paths


module "api_path_parameters" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "reporting"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = data.terraform_remote_state.staging.outputs.api_gateway_internal_root_resource
}

