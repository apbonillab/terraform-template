provider "aws" {
  region  = "us-east-1"
}

terraform {
  required_version = ">= 0.12, < 0.13"
  backend "s3" {
    bucket         = "state-staging"
    key            = "staging-main/api-gateway/test/clients/terraform.tfstate"
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

module "api_path_clients" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "client"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = data.terraform_remote_state.staging.outputs.api_gateway_internal_root_resource
}

module "api_path_validations" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "validations"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_clients.api_gateway_resource_parent_id
}

module "api_path_validations_email" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "email"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_validations.api_gateway_resource_parent_id
}

module "api_path_validations_card" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "card"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_validations.api_gateway_resource_parent_id
}

module "api_path_password" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "password"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = data.terraform_remote_state.staging.outputs.api_gateway_internal_root_resource
}

module "api_path_recover" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "recover"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_password.api_gateway_resource_parent_id
}

// Recursos secundarios

//Init Subpaths clients

module "api_path_client_id" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "id"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_clients.api_gateway_resource_parent_id
}

module "api_path_client_id_param" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "{id}"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_clients.api_gateway_resource_parent_id
}
module "api_path_client_phone_number" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "phone_number"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_clients.api_gateway_resource_parent_id
}

module "api_path_client_products" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "products"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_clients.api_gateway_resource_parent_id
}

// End subpaths clients

// Init subpaths validations

module "api_subpath_validation_email" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "{email}"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_validations_email.api_gateway_resource_parent_id
}

module "api_subpath_validation_card" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "{cardId}"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_validations_card.api_gateway_resource_parent_id
}

module "api_path_validation_phone_number" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "phone_number"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_validations.api_gateway_resource_parent_id
}

module "api_path_validations_id_param" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "{id}"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_validations.api_gateway_resource_parent_id
}

// End subpaths validations

// init subpaths password

module "api_path_password_validate" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "validate"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_password.api_gateway_resource_parent_id
}

module "api_path_recover_email" {
  source                                           = "../../../api_gw/api_gw_paths"
  api_gateway_path_part                            = "email"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  api_gateway_parent_id                            = module.api_path_recover.api_gateway_resource_parent_id
}

// end subpaths password

//Resources and integration response

module "api_gateway_client" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = "bc-alb-1452588881.us-east-1.elb.amazonaws.com"
  api_gateway_http_method                          = "POST"
  api_gateway_method_integration_http_method       = "POST"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/clients/"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = {}
  api_gateway_integration_request_parameters       = {}
  api_gateway_resource_id                          = module.api_path_client_id.api_gateway_resource_parent_id
  api_gateway_path_part                            = "id"
  }

module "api_gateway_client_id" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = "bc-alb-1452588881.us-east-1.elb.amazonaws.com"
  api_gateway_http_method                          = "GET"
  api_gateway_method_integration_http_method       = "GET"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/clients/idClient/{id}"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = { "method.request.path.id" = true}
  api_gateway_integration_request_parameters       = { "integration.request.path.id" = "method.request.path.id"}
  api_gateway_resource_id                          = module.api_path_client_id_param.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_path_client_id_param.api_gateway_path

}

module "api_gateway_client_pending_validations" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = "bc-alb-1452588881.us-east-1.elb.amazonaws.com"
  api_gateway_http_method                          = "GET"
  api_gateway_method_integration_http_method       = "GET"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/clients/pendingvalidations/{id}"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_path_part                            = module.api_path_validations_id_param.api_gateway_path
  api_gateway_request_parameters                   = { "method.request.path.id" = true}
  api_gateway_integration_request_parameters       = { "integration.request.path.id" = "method.request.path.id"}
  api_gateway_resource_id                          = module.api_path_validations_id_param.api_gateway_resource_parent_id
}


/*
module "api_gateway_client_phone_number" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = "bc-alb-1452588881.us-east-1.elb.amazonaws.com"
  api_gateway_http_method                          = "GET"
  api_gateway_method_integration_http_method       = "GET"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/clients/phonenumber/"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = {}
  api_gateway_integration_request_parameters       = {}
  api_gateway_resource_id                          = module.api_path_client_phone_number.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_path_client_phone_number.api_gateway_path
  api_gateway_stage_name                           = data.terraform_remote_state.staging.outputs.api_gateway_internal_stage_name
}*/


module "api_gateway_client_products" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = "bc-alb-1452588881.us-east-1.elb.amazonaws.com"
  api_gateway_http_method                          = "GET"
  api_gateway_method_integration_http_method       = "GET"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/clients/products/{id}"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = { "method.request.path.id" = true}
  api_gateway_integration_request_parameters       = { "integration.request.path.id" = "method.request.path.id"}
  api_gateway_resource_id                          = module.api_path_client_products.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_path_client_products.api_gateway_path

}

module "api_gateway_client_update" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = "bc-alb-1452588881.us-east-1.elb.amazonaws.com"
  api_gateway_http_method                          = "PUT"
  api_gateway_method_integration_http_method       = "POST"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/clients/profile/update"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = {}
  api_gateway_integration_request_parameters       = {}
  api_gateway_resource_id                          = module.api_path_clients.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_path_clients.api_gateway_path

}


module "api_gateway_password_update" {    
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = "bc-alb-1452588881.us-east-1.elb.amazonaws.com"
  api_gateway_http_method                          = "PUT"
  api_gateway_method_integration_http_method       = "POST"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/clients/password/update/"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = {}
  api_gateway_integration_request_parameters       = {}
  api_gateway_path_part                            = module.api_path_password.api_gateway_path
  api_gateway_resource_id                          = module.api_path_password.api_gateway_resource_parent_id

}


module "api_gateway_password_validate" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = "bc-alb-1452588881.us-east-1.elb.amazonaws.com"
  api_gateway_http_method                          = "POST" 
  api_gateway_method_integration_http_method       = "POST"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/clients/password/validate/"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = {}
  api_gateway_integration_request_parameters       = {}
  api_gateway_resource_id                          = module.api_path_password_validate.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_path_password_validate.api_gateway_path

}


module "api_gateway_recover_password_update" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = "bc-alb-1452588881.us-east-1.elb.amazonaws.com"
  api_gateway_http_method                          = "PUT" 
  api_gateway_method_integration_http_method       = "POST"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/clients/recoverPassword/updatePassword"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = {}
  api_gateway_integration_request_parameters       = {}
  api_gateway_resource_id                          = module.api_path_recover.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_path_recover.api_gateway_path

}


module "api_gateway_recover_send_email" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = "bc-alb-1452588881.us-east-1.elb.amazonaws.com"
  api_gateway_http_method                          = "POST" 
  api_gateway_method_integration_http_method       = "POST"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/clients/recoverPassword/sendEmail"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = {}
  api_gateway_integration_request_parameters       = {}
  api_gateway_resource_id                          = module.api_path_recover_email.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_path_recover_email.api_gateway_path

}


module "api_gateway_validator_email" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = "bc-alb-1452588881.us-east-1.elb.amazonaws.com"
  api_gateway_http_method                          = "GET"
  api_gateway_method_integration_http_method       = "GET"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/clients/validations/email/{email}"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = { "method.request.path.email" = true}
  api_gateway_integration_request_parameters       = { "integration.request.path.email" = "method.request.path.email"}
  api_gateway_resource_id                          = module.api_subpath_validation_email.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_subpath_validation_email.api_gateway_path

}


module "api_gateway_validator_card_id" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = "bc-alb-1452588881.us-east-1.elb.amazonaws.com"
  api_gateway_http_method                          = "GET"
  api_gateway_method_integration_http_method       = "GET"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "/clients/validations/idcard/{cardId}"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = { "method.request.path.cardId" = true}
  api_gateway_integration_request_parameters       = { "integration.request.path.cardId" = "method.request.path.cardId"}
  api_gateway_resource_id                          = module.api_subpath_validation_card.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_subpath_validation_card.api_gateway_path

}

module "api_gateway_deploy" {
        source  = "../../../api_gw/api_gw_deploy"
        api_gateway_cloudtwatch_name = "global"
        api_gateway_rest_api_id = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
}

/*
module "api_gateway_validator_phone_number" {
  source                                           = "../../../api_gw/api_gw_resources"
  alb_endpoint                                     = ""bc-alb-1452588881.us-east-1.elb.amazonaws.com"
  api_gateway_http_method                          = "GET"
  api_gateway_method_integration_http_method       = "GET"
  api_gateway_rest_api_id                          = data.terraform_remote_state.staging.outputs.api_gateway_internal_id
  uri_resource_service_name                        = "clients/validations/phonenumber"
  api_gateway_integration_type                     = "HTTP_PROXY"
  api_gateway_authorizer_id                        = ""
  api_gateway_authorization                        = "NONE"
  api_gateway_request_parameters                   = {}
  api_gateway_integration_request_parameters       = {}
  api_gateway_resource_id                          = module.api_path_validation_phone_number.api_gateway_resource_parent_id
  api_gateway_path_part                            = module.api_path_validation_phone_number.api_gateway_path
  api_gateway_stage_name                           = data.terraform_remote_state.staging.outputs.api_gateway_internal_stage_name
}
*/