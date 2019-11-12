provider "aws" {
  region = "us-east-1"
  profile = "staging"
}

terraform {
  required_version = ">= 0.12, < 0.13"
  backend "s3" {
    bucket         = "gnb-mgmt-terraform-state-stg"
    key            = "staging-main/api_gw/transactions/terraform.tfstate"
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

module "api_path_trasnfers" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "transfers"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = data.terraform_remote_state.staging.outputs.api_gateway_internal_root_resource
}


module "api_transfer_pending" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "pending_approval"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_trasnfers.api_gateway_resource_parent_id
}

module "api_transfer_trasferenciasya" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "transferenciasya"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_trasnfers.api_gateway_resource_parent_id
}

module "api_transfer_frequent" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "frequent"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_trasnfers.api_gateway_resource_parent_id
}


module "api_transfer_pending_transactions" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "pending_transaction"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_trasnfers.api_gateway_resource_parent_id
}

module "api_transfer_reject" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "reject"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_trasnfers.api_gateway_resource_parent_id
}

module "api_transfer_channel" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "channel"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_trasnfers.api_gateway_resource_parent_id
}

module "api_transfer_request_lulo" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "request_lulo"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_trasnfers.api_gateway_resource_parent_id
}

module "api_transfer_send_lulo" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "send_lulo"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_trasnfers.api_gateway_resource_parent_id
}

module "api_transfer_request" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "request"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_trasnfers.api_gateway_resource_parent_id
}

module "api_transfer_send" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "send"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_trasnfers.api_gateway_resource_parent_id
}

module "api_gateway_transfer_approval" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = data.terraform_remote_state.staging.outputs.alb_endpoint
  api_gateway_http_method                          = "POST"
  api_gateway_method_integration_http_method       = "POST"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/transactions/transfers/pending/approval"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = { }
  api_gateway_integration_request_parameters       = {}
  api_gateway_resource_id                          = module.api_transfer_pending.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_transfer_pending.api_gateway_path
  api_gateway_stage_name                           = data.terraform_remote_state.staging.outputs.api_gateway_internal_stage_name
}

module "api_gateway_transfer_ya" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = data.terraform_remote_state.staging.outputs.alb_endpoint
  api_gateway_http_method                          = "POST"
  api_gateway_method_integration_http_method       = "POST"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/transactions/transfers/transferenciasya/trust-link"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = { }
  api_gateway_integration_request_parameters       = {}
  api_gateway_resource_id                          = module.api_transfer_trasferenciasya.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_transfer_trasferenciasya.api_gateway_path
  api_gateway_stage_name                           = data.terraform_remote_state.staging.outputs.api_gateway_internal_stage_name
}

module "api_gateway_frequent" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = data.terraform_remote_state.staging.outputs.alb_endpoint
  api_gateway_http_method                          = "GET"
  api_gateway_method_integration_http_method       = "GET"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/transactions/transfers/client/{idClient}/frequent-contacts"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = { "method.request.path.idClient" = true}
  api_gateway_integration_request_parameters       = { "integration.request.path.idClient" = "method.request.path.idClient"}
  api_gateway_resource_id                          = module.api_transfer_frequent.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_transfer_frequent.api_gateway_path
  api_gateway_stage_name                           = data.terraform_remote_state.staging.outputs.api_gateway_internal_stage_name
}

module "api_gateway_pending_trans" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = data.terraform_remote_state.staging.outputs.alb_endpoint
  api_gateway_http_method                          = "GET"
  api_gateway_method_integration_http_method       = "GET"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/transactions/transfers/pending/client/{idClient}"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = { "method.request.path.idClient" = true}
  api_gateway_integration_request_parameters       = { "integration.request.path.idClient" = "method.request.path.idClient"}
  api_gateway_resource_id                          = module.api_transfer_pending_transactions.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_transfer_pending_transactions.api_gateway_path
  api_gateway_stage_name                           = data.terraform_remote_state.staging.outputs.api_gateway_internal_stage_name
}

module "api_gateway_reject" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = data.terraform_remote_state.staging.outputs.alb_endpoint
  api_gateway_http_method                          = "POST"
  api_gateway_method_integration_http_method       = "POST"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/transactions/transfers/pending/reject"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = {}
  api_gateway_integration_request_parameters       = {}
  api_gateway_resource_id                          = module.api_transfer_reject.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_transfer_reject.api_gateway_path
  api_gateway_stage_name                           = data.terraform_remote_state.staging.outputs.api_gateway_internal_stage_name
}


module "api_gateway_channel" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = data.terraform_remote_state.staging.outputs.alb_endpoint
  api_gateway_http_method                          = "GET"
  api_gateway_method_integration_http_method       = "GET"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/transactions/transfers/channel"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = {}
  api_gateway_integration_request_parameters       = {}
  api_gateway_resource_id                          = module.api_transfer_channel.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_transfer_channel.api_gateway_path
  api_gateway_stage_name                           = data.terraform_remote_state.staging.outputs.api_gateway_internal_stage_name
}



module "api_gateway_request_lulo" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = data.terraform_remote_state.staging.outputs.alb_endpoint
  api_gateway_http_method                          = "POST"
  api_gateway_method_integration_http_method       = "POST"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/transactions/transfers/request/lulo"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = {}
  api_gateway_integration_request_parameters       = {}
  api_gateway_resource_id                          = module.api_transfer_request_lulo.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_transfer_request_lulo.api_gateway_path
  api_gateway_stage_name                           = data.terraform_remote_state.staging.outputs.api_gateway_internal_stage_name
}


module "api_gateway_request" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = data.terraform_remote_state.staging.outputs.alb_endpoint
  api_gateway_http_method                          = "POST"
  api_gateway_method_integration_http_method       = "POST"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/transactions/transfers/request/transferenciasya"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = {}
  api_gateway_integration_request_parameters       = {}
  api_gateway_resource_id                          = module.api_transfer_request.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_transfer_request.api_gateway_path
  api_gateway_stage_name                           = data.terraform_remote_state.staging.outputs.api_gateway_internal_stage_name
}

module "api_gateway_send" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = data.terraform_remote_state.staging.outputs.alb_endpoint
  api_gateway_http_method                          = "POST"
  api_gateway_method_integration_http_method       = "POST"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/transactions/transfers/send/transferenciasya"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = {}
  api_gateway_integration_request_parameters       = {}
  api_gateway_resource_id                          = module.api_transfer_send.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_transfer_send.api_gateway_path
  api_gateway_stage_name                           = data.terraform_remote_state.staging.outputs.api_gateway_internal_stage_name
}