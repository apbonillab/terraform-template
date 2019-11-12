provider "aws" {
  region = "us-east-1"
  profile = "staging"
}

terraform {
  required_version = ">= 0.12, < 0.13"
  backend "s3" {
    bucket         = "gnb-mgmt-terraform-state-stg"
    key            = "staging-main/api_gw/otp/terraform.tfstate"
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

module "api_path_otp" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "otp"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = data.terraform_remote_state.staging.outputs.api_gateway_internal_root_resource
}


module "api_generate_otp" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "generate"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_otp.api_gateway_resource_parent_id
}

module "api_verify_otp" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "verify"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_otp.api_gateway_resource_parent_id
}

module "api_gateway_generate" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = data.terraform_remote_state.staging.outputs.alb_endpoint
  api_gateway_http_method                          = "POST"
  api_gateway_method_integration_http_method       = "POST"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/otp/generate/country/{prefix}/phonenumber/{phonenumber}"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = { "method.request.path.prefix" = true,  "method.request.path.phonenumber" = true}
  api_gateway_integration_request_parameters       = { "integration.request.path.prefix" = "method.request.path.prefix", "integration.request.path.phonenumber" = "method.request.path.phonenumber"}
  api_gateway_resource_id                          = module.api_generate_otp.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_generate_otp.api_gateway_path
  api_gateway_stage_name                           = data.terraform_remote_state.staging.outputs.api_gateway_internal_stage_name
}


module "api_gateway_products_offer" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = data.terraform_remote_state.staging.outputs.alb_endpoint
  api_gateway_http_method                          = "GET"
  api_gateway_method_integration_http_method       = "GET"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/otp/verify/country/{prefix}/phonenumber/{phonenumber}/token/{token}"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = { "method.request.path.prefix" = true,  "method.request.path.phonenumber" = true}
  api_gateway_integration_request_parameters       = { "integration.request.path.prefix" = "method.request.path.prefix", "integration.request.path.phonenumber" = "method.request.path.phonenumber"}
  api_gateway_resource_id                          = module.api_verify_otp.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_verify_otp.api_gateway_path
  api_gateway_stage_name                           = data.terraform_remote_state.staging.outputs.api_gateway_internal_stage_name
}

