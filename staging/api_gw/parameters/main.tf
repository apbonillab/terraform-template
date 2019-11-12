provider "aws" {
  region  = "us-east-1"
}

terraform {
  required_version = ">= 0.12, < 0.13"
  backend "s3" {
    bucket         = "state-staging"
    key            = "staging-main/api-gateway/parameters/terraform.tfstate"
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

module "api_path_parameters" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "parameters"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = data.terraform_remote_state.staging.outputs.api_gateway_internal_root_resource
}


module "api_generate_atm" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "atm"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_parameters.api_gateway_resource_parent_id
}

module "api_generate_country" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "countries"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_parameters.api_gateway_resource_parent_id
}

module "api_generate_country_department" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "department"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_generate_country.api_gateway_resource_parent_id
}

module "api_generate_country_cities" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "cities"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_generate_country.api_gateway_resource_parent_id
}

module "api_generate_currency" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "currency"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_parameters.api_gateway_resource_parent_id
}


module "api_gateway_atm_get" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = "bc-alb-1452588881.us-east-1.elb.amazonaws.com"
  api_gateway_http_method                          = "GET"
  api_gateway_method_integration_http_method       = "GET"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/parameters/atm"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = {}
  api_gateway_integration_request_parameters       = {}
  api_gateway_resource_id                          = module.api_path_parameters.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_path_parameters.api_gateway_path
}


module "api_gateway_atm_save" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = "bc-alb-1452588881.us-east-1.elb.amazonaws.com"
  api_gateway_http_method                          = "POST"
  api_gateway_method_integration_http_method       = "POST"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/parameters/atm"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = {}
  api_gateway_integration_request_parameters       = {}
  api_gateway_resource_id                          = module.api_path_parameters.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_path_parameters.api_gateway_path
}

module "api_gateway_countries_get" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = "bc-alb-1452588881.us-east-1.elb.amazonaws.com"
  api_gateway_http_method                          = "GET"
  api_gateway_method_integration_http_method       = "GET"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/parameters/countries"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = {}
  api_gateway_integration_request_parameters       = {}
  api_gateway_resource_id                          = module.api_generate_country.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_generate_country.api_gateway_path
}

module "api_gateway_countries_department" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = "bc-alb-1452588881.us-east-1.elb.amazonaws.com"
  api_gateway_http_method                          = "GET"
  api_gateway_method_integration_http_method       = "GET"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/parameters/countries/{countryCode}/departments"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = { "method.request.path.countryCode" = true}
  api_gateway_integration_request_parameters       = { "integration.request.path.countryCode" = "method.request.path.countryCode"}
  api_gateway_resource_id                          = module.api_generate_country_department.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_generate_country_department.api_gateway_path
}

module "api_gateway_countries_cities" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = "bc-alb-1452588881.us-east-1.elb.amazonaws.com"
  api_gateway_http_method                          = "GET"
  api_gateway_method_integration_http_method       = "GET"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/parameters/countries/{countryCode}/departments/{departmentCode}/cities"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = { "method.request.path.countryCode" = true, "method.request.path.departmentCode" = true}
  api_gateway_integration_request_parameters       = { "integration.request.path.countryCode" = "method.request.path.countryCode",  "integration.request.path.departmentCode" = "method.request.path.departmentCode"}
  api_gateway_resource_id                          = module.api_generate_country_cities.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_generate_country_cities.api_gateway_path
}

module "api_gateway_currencies" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = "bc-alb-1452588881.us-east-1.elb.amazonaws.com"
  api_gateway_http_method                          = "GET"
  api_gateway_method_integration_http_method       = "GET"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_integration_type                     = "HTTP_PROXY"
  uri_resource_service_name                        = "/parameters/currencies"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = {}
  api_gateway_integration_request_parameters       = {}
  api_gateway_resource_id                          = module.api_path_parameters.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_path_parameters.api_gateway_path
 }

module "api_gateway_deploy_parameters" {
  source  = "../../../api_gw/api_gw_deploy"
  api_gateway_cloudtwatch_name = "global_parameters"
  api_gateway_rest_api_id = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
}