provider "aws" {
  region = "us-east-1"
  profile = "staging"
}

terraform {
  required_version = ">= 0.12, < 0.13"
  backend "s3" {
    bucket         = "gnb-mgmt-terraform-state-stg"
    key            = "staging-main/api_gw/credits/terraform.tfstate"
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

module "api_path_credits" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "credits"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = data.terraform_remote_state.staging.outputs.api_gateway_internal_root_resource
}


module "api_path_products" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "products"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_credits.api_gateway_resource_parent_id
}

module "api_path_products_initial_offer" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "initial_offer"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_products.api_gateway_resource_parent_id
}

module "api_path_products_offer" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "offer"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_products_initial_offer.api_gateway_resource_parent_id
}

module "api_path_products_offer_accept" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "offer_accept"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_products_initial_offer.api_gateway_resource_parent_id
}

module "api_path_products_offer_client" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "offer_client"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_products_initial_offer.api_gateway_resource_parent_id
}

module "api_path_loan" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "loan"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_products_initial_offer.api_gateway_resource_parent_id
}


module "api_path_payment_plan" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "payment_plan"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_products_initial_offer.api_gateway_resource_parent_id
}


module "api_path_initial_products" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "initial_products"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_products_initial_offer.api_gateway_resource_parent_id
}


module "api_path_payment" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "payment"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_products_initial_offer.api_gateway_resource_parent_id
}
// End paths

//Resources and integration response

module "api_gateway_products_initial_offer" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = data.terraform_remote_state.staging.outputs.alb_endpoint
  api_gateway_http_method                          = "POST"
  api_gateway_method_integration_http_method       = "POST"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/credits/products/initial-offer"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = {}
  api_gateway_integration_request_parameters       = {}
  api_gateway_resource_id                          = module.api_path_products_initial_offer.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_path_products_initial_offer.api_gateway_path
  api_gateway_stage_name                           = data.terraform_remote_state.staging.outputs.api_gateway_internal_stage_name
}


module "api_gateway_products_offer" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = data.terraform_remote_state.staging.outputs.alb_endpoint
  api_gateway_http_method                          = "POST"
  api_gateway_method_integration_http_method       = "POST"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/credits/products/offer"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = {}
  api_gateway_integration_request_parameters       = {}
  api_gateway_resource_id                          = module.api_path_products_offer.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_path_products_offer.api_gateway_path
  api_gateway_stage_name                           = data.terraform_remote_state.staging.outputs.api_gateway_internal_stage_name
}


module "api_gateway_products_offer_accept" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = data.terraform_remote_state.staging.outputs.alb_endpoint
  api_gateway_http_method                          = "POST"
  api_gateway_method_integration_http_method       = "POST"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/credits/products/offer/accept"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = {}
  api_gateway_integration_request_parameters       = {}
  api_gateway_resource_id                          = module.api_path_products_offer_accept.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_path_products_offer_accept.api_gateway_path
  api_gateway_stage_name                           = data.terraform_remote_state.staging.outputs.api_gateway_internal_stage_name
}

module "api_gateway_products_offer_client" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = data.terraform_remote_state.staging.outputs.alb_endpoint
  api_gateway_http_method                          = "GET"
  api_gateway_method_integration_http_method       = "GET"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/credits/products/offer/client/{idClient}"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = { "method.request.path.idClient" = true}
  api_gateway_integration_request_parameters       = { "integration.request.path.idClient" = "method.request.path.idClient"}
  api_gateway_resource_id                          = module.api_path_products_offer_client.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_path_products_offer_client.api_gateway_path
  api_gateway_stage_name                           = data.terraform_remote_state.staging.outputs.api_gateway_internal_stage_name

}

module "api_gateway_loan" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = data.terraform_remote_state.staging.outputs.alb_endpoint
  api_gateway_http_method                          = "GET"
  api_gateway_method_integration_http_method       = "GET"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/credits/{idClient}/products"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = { "method.request.path.idClient" = true}
  api_gateway_integration_request_parameters       = { "integration.request.path.idClient" = "method.request.path.idClient"}
  api_gateway_resource_id                          = module.api_path_loan.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_path_loan.api_gateway_path
  api_gateway_stage_name                           = data.terraform_remote_state.staging.outputs.api_gateway_internal_stage_name
}

module "api_gateway_loan_payment" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = data.terraform_remote_state.staging.outputs.alb_endpoint
  api_gateway_http_method                          = "GET"
  api_gateway_method_integration_http_method       = "GET"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/credits/{idCredit}/payment-plan"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = { "method.request.path.idClient" = true}
  api_gateway_integration_request_parameters       = { "integration.request.path.idClient" = "method.request.path.idClient"}
  api_gateway_resource_id                          = module.api_path_payment.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_path_payment.api_gateway_path
  api_gateway_stage_name                           = data.terraform_remote_state.staging.outputs.api_gateway_internal_stage_name
}

module "api_gateway_initial_products" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = data.terraform_remote_state.staging.outputs.alb_endpoint
  api_gateway_http_method                          = "POST"
  api_gateway_method_integration_http_method       = "POST"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/credits/initial/products"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = {}
  api_gateway_integration_request_parameters       = {}
  api_gateway_resource_id                          = module.api_path_initial_products.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_path_initial_products.api_gateway_path
  api_gateway_stage_name                           = data.terraform_remote_state.staging.outputs.api_gateway_internal_stage_name
}

module "api_gateway_payment_credit" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = data.terraform_remote_state.staging.outputs.alb_endpoint
  api_gateway_http_method                          = "POST"
  api_gateway_method_integration_http_method       = "POST"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/credits/payment/credit"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = {}
  api_gateway_integration_request_parameters       = {}
  api_gateway_resource_id                          = module.api_path_payment.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_path_payment.api_gateway_path
  api_gateway_stage_name                           = data.terraform_remote_state.staging.outputs.api_gateway_internal_stage_name
}