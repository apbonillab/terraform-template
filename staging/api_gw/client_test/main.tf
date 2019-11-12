provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = ">= 0.12, < 0.13"
  backend "s3" {
    bucket         = "state"
    key            = "staging-main/api-gateway/test/clients/terraform.tfstate"
    region         = "us-east-1"

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
// API Gateway

module "api_gateway_test" {
  source                                           = "../../../api_gw/api_gw_init"
  api_gateway_name                                 = "internal_test"
  api_gateway_authorizer_name                      = "internal_api_gateway_authorizer"
  api_authorizer_lambda_invoke_arn                 = data.terraform_remote_state.staging.outputs.lambda_authorizer_invoke_arn
  invocation_role_arn                              = data.terraform_remote_state.staging.outputs.lambda_invocation_role_arn
  api_gateway_cloudtwatch_name                     = "api_gateway_cloudwatch_globals"
}

// Paths

module "api_path_clients" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "client"
  api_gateway_rest_api_id                          = module.api_gateway_test.api_gateway_id
  api_gateway_parent_id                            = module.api_gateway_test.api_gateway_root_resource
}

// Recursos secundarios

//Init Subpaths clients

module "api_path_client_id" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "id"
  api_gateway_rest_api_id                          = module.api_gateway_test.api_gateway_id
  api_gateway_parent_id                            = module.api_path_clients.api_gateway_resource_parent_id
}

//Resources and integration response

module "api_gateway_client" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = data.terraform_remote_state.staging.outputs.alb_endpoint
  api_gateway_http_method                          = "POST"
  api_gateway_method_integration_http_method       = "POST"
  api_gateway_rest_api_id                          = module.api_gateway_test.api_gateway_id
  uri_resource_service_name                        = "/clients/id-client"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = {}
  api_gateway_integration_request_parameters       = {}
  api_gateway_resource_id                          = module.api_path_client_id.api_gateway_resource_parent_id
  api_gateway_path_part                            =  module.api_path_client_id.api_gateway_path
  api_gateway_stage_name                           = module.api_gateway_test.api_gateway_stage_name
}
