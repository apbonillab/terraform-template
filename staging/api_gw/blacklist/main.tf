provider "aws" {
  region  = "us-east-1"
}

terraform {
  required_version = ">= 0.12, < 0.13"
  backend "s3" {
    bucket         = "state-staging"
    key            = "staging-main/api-gateway/blacklist/terraform.tfstate"
    region         = "us-east-1"

  }
}

// remote_state


data "terraform_remote_state" "staging" {
  backend = "s3"

  config = {
    bucket         = "state-staging"
    key            = "staging-main/terraform.tfstate"
    region         = "us-east-1"
  }
}

// Paths

module "api_path_blacklist" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "blacklist"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = data.terraform_remote_state.staging.outputs.api_gateway_internal_root_resource
}


module "api_path_identity" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "identity"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_blacklist.api_gateway_resource_parent_id
}

module "api_path_validation" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "validations"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_blacklist.api_gateway_resource_parent_id
}

module "api_path_applicant" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "{idIdentityApplicant}"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_identity.api_gateway_resource_parent_id
}

module "api_path_applicant_post" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "applicant"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_identity.api_gateway_resource_parent_id
}

// End paths

//Resources and integration response

module "api_gateway_identity" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = "bc-alb-1452588881.us-east-1.elb.amazonaws.com"
  api_gateway_http_method                          = "POST"
  api_gateway_method_integration_http_method       = "POST"
    api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/blacklist/identity/applicant"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = {}
  api_gateway_integration_request_parameters       = {}
  api_gateway_resource_id                          = module.api_path_applicant_post.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_path_applicant_post.api_gateway_path
  }



module "api_gateway_identity_check" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = "bc-alb-1452588881.us-east-1.elb.amazonaws.com"
  api_gateway_http_method                          = "GET"
  api_gateway_method_integration_http_method       = "GET"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/blacklist/identity/check/applicant/{idIdentityApplicant}"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = { "method.request.path.idIdentityApplicant" = true}
  api_gateway_integration_request_parameters       = { "integration.request.path.idIdentityApplicant" = "method.request.path.idIdentityApplicant"}
  api_gateway_resource_id                          = module.api_path_applicant.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_path_applicant.api_gateway_path
 }

module "api_gateway_deploy_blacklist" {
  source  = "../../../api_gw/api_gw_deploy"
  api_gateway_cloudtwatch_name = "global_blacklist"
  api_gateway_rest_api_id = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
}

/*
module "api_gateway_validation_client" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = "bc-alb-1452588881.us-east-1.elb.amazonaws.com"
  api_gateway_http_method                          = "GET"
  api_gateway_method_integration_http_method       = "GET"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/blacklist/validations/blacklistClient"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = {}
  api_gateway_integration_request_parameters       = {}
  api_gateway_resource_id                          = module.api_path_validation.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_path_validation.api_gateway_path
  api_gateway_stage_name                           = data.terraform_remote_state.staging.outputs.api_gateway_internal_stage_name
}*/



