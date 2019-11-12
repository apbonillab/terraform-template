
// API Gateway and Cognito Authorizer

resource "aws_api_gateway_rest_api" "external_api_gw_external" {
  name        = var.api_gateway_name_external
  description = "This is the external API for lulobank"
}

resource "aws_api_gateway_authorizer" "api_gw_external_authorizer" {
  name                   = "external_api_gw_authorizer"
  rest_api_id            = aws_api_gateway_rest_api.external_api_gw_external.id
  type                   = "COGNITO_USER_POOLS"
  provider_arns          = [var.aws_cognito_user_pool_arn]
}

// Resources

resource "aws_api_gateway_resource" "transferenciasya_credit_resource" {
  rest_api_id = aws_api_gateway_rest_api.external_api_gw_external.id
  parent_id   = aws_api_gateway_rest_api.external_api_gw_external.root_resource_id
  path_part   = "credit"
}

resource "aws_api_gateway_resource" "transferenciasya_debit_resource" {
  rest_api_id = aws_api_gateway_rest_api.external_api_gw_external.id
  parent_id   = aws_api_gateway_rest_api.external_api_gw_external.root_resource_id
  path_part   = "debit"
}

resource "aws_api_gateway_resource" "transferenciasya_status_resource" {
  rest_api_id = aws_api_gateway_rest_api.external_api_gw_external.id
  parent_id   = aws_api_gateway_rest_api.external_api_gw_external.root_resource_id
  path_part   = "status"
}

resource "aws_api_gateway_resource" "transferenciasya_transfer_resource" {
  rest_api_id = aws_api_gateway_rest_api.external_api_gw_external.id
  parent_id   = aws_api_gateway_rest_api.external_api_gw_external.root_resource_id
  path_part   = "transfer"
}

// Method: /v1/credit POST

resource "aws_api_gateway_method" "transferenciasya_credit_post_method" {
  rest_api_id          = aws_api_gateway_rest_api.external_api_gw_external.id
  resource_id          = aws_api_gateway_resource.transferenciasya_credit_resource.id
  http_method          = "POST"
  authorization        = "COGNITO_USER_POOLS"
  authorizer_id        = aws_api_gateway_authorizer.api_gw_external_authorizer.id
  authorization_scopes = ["transferenciasya/credit"]
}

resource "aws_api_gateway_integration" "transferenciasya_credit_integration" {
  rest_api_id = aws_api_gateway_rest_api.external_api_gw_external.id
  resource_id = aws_api_gateway_resource.transferenciasya_credit_resource.id
  http_method = aws_api_gateway_method.transferenciasya_credit_post_method.http_method
  integration_http_method = "POST"
  type                    = "HTTP_PROXY"
  uri                     = "http://${var.flexibility_endpoint}/ach-endpoint/v1/credit"
}

resource "aws_api_gateway_method" "transferenciasya_credit_options_method" {
  rest_api_id          = aws_api_gateway_rest_api.external_api_gw_external.id
  resource_id          = aws_api_gateway_resource.transferenciasya_credit_resource.id
  http_method          = "OPTIONS"
  authorization        = "COGNITO_USER_POOLS"
  authorizer_id        = aws_api_gateway_authorizer.api_gw_external_authorizer.id
  authorization_scopes = ["transferenciasya/credit"]
}

resource "aws_api_gateway_integration" "transferenciasya_credit_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.external_api_gw_external.id
  resource_id = aws_api_gateway_resource.transferenciasya_credit_resource.id
  http_method = aws_api_gateway_method.transferenciasya_credit_options_method.http_method
  type = "MOCK"                           # Documentation not clear
  request_templates = {                  # Not documented
    "application/json" = "{'statusCode': 200}"
  }
  passthrough_behavior = "WHEN_NO_MATCH"
}

module "transferenciasya_credit_responses" {
  source         = "./responses"
  api_gateway_id = aws_api_gateway_rest_api.external_api_gw_external.id
  resource_id    = aws_api_gateway_resource.transferenciasya_credit_resource.id
  http_method    = aws_api_gateway_method.transferenciasya_credit_post_method.http_method
  name           = "Credit"
}

// Method: /v1/debit POST

resource "aws_api_gateway_method" "transferenciasya_debit_post_method" {
  rest_api_id          = aws_api_gateway_rest_api.external_api_gw_external.id
  resource_id          = aws_api_gateway_resource.transferenciasya_debit_resource.id
  http_method          = "POST"
  authorization        = "COGNITO_USER_POOLS"
  authorizer_id        = aws_api_gateway_authorizer.api_gw_external_authorizer.id
  authorization_scopes = ["transferenciasya/debit"]
}

resource "aws_api_gateway_integration" "transferenciasya_debit_integration" {
  rest_api_id = aws_api_gateway_rest_api.external_api_gw_external.id
  resource_id = aws_api_gateway_resource.transferenciasya_debit_resource.id
  http_method = aws_api_gateway_method.transferenciasya_debit_post_method.http_method
  integration_http_method = "POST"
  type                    = "HTTP_PROXY"
  uri                     = "http://${var.flexibility_endpoint}/ach-endpoint/v1/debit"
}

resource "aws_api_gateway_method" "transferenciasya_debit_options_method" {
  rest_api_id          = aws_api_gateway_rest_api.external_api_gw_external.id
  resource_id          = aws_api_gateway_resource.transferenciasya_debit_resource.id
  http_method          = "OPTIONS"
  authorization        = "COGNITO_USER_POOLS"
  authorizer_id        = aws_api_gateway_authorizer.api_gw_external_authorizer.id
  authorization_scopes = ["transferenciasya/debit"]
}

resource "aws_api_gateway_integration" "transferenciasya_debit_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.external_api_gw_external.id
  resource_id = aws_api_gateway_resource.transferenciasya_debit_resource.id
  http_method = aws_api_gateway_method.transferenciasya_debit_options_method.http_method
  type = "MOCK"                           # Documentation not clear
  request_templates = {                  # Not documented
    "application/json" = "{'statusCode': 200}"
  }
  passthrough_behavior = "WHEN_NO_MATCH"
}

module "transferenciasya_debit_responses" {
  source         = "./responses"
  api_gateway_id = aws_api_gateway_rest_api.external_api_gw_external.id
  resource_id    = aws_api_gateway_resource.transferenciasya_debit_resource.id
  http_method    = aws_api_gateway_method.transferenciasya_debit_post_method.http_method
  name           = "Debit"
}

// Method: /v1/status POST

resource "aws_api_gateway_method" "transferenciasya_status_post_method" {
  rest_api_id          = aws_api_gateway_rest_api.external_api_gw_external.id
  resource_id          = aws_api_gateway_resource.transferenciasya_status_resource.id
  http_method          = "POST"
  authorization        = "COGNITO_USER_POOLS"
  authorizer_id        = aws_api_gateway_authorizer.api_gw_external_authorizer.id
  authorization_scopes = ["transferenciasya/status"]
}

resource "aws_api_gateway_integration" "transferenciasya_status_integration" {
  rest_api_id = aws_api_gateway_rest_api.external_api_gw_external.id
  resource_id = aws_api_gateway_resource.transferenciasya_status_resource.id
  http_method = aws_api_gateway_method.transferenciasya_status_post_method.http_method
  integration_http_method = "POST"
  type                    = "HTTP_PROXY"
  uri                     = "http://${var.flexibility_endpoint}/ach-endpoint/v1/status"
}

resource "aws_api_gateway_method" "transferenciasya_status_options_method" {
  rest_api_id          = aws_api_gateway_rest_api.external_api_gw_external.id
  resource_id          = aws_api_gateway_resource.transferenciasya_status_resource.id
  http_method          = "OPTIONS"
  authorization        = "COGNITO_USER_POOLS"
  authorizer_id        = aws_api_gateway_authorizer.api_gw_external_authorizer.id
  authorization_scopes = ["transferenciasya/status"]
}

resource "aws_api_gateway_integration" "transferenciasya_status_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.external_api_gw_external.id
  resource_id = aws_api_gateway_resource.transferenciasya_status_resource.id
  http_method = aws_api_gateway_method.transferenciasya_status_options_method.http_method
  type = "MOCK"                           # Documentation not clear
  request_templates = {                  # Not documented
    "application/json" = "{'statusCode': 200}"
  }
  passthrough_behavior = "WHEN_NO_MATCH"
}

module "transferenciasya_status_responses" {
  source         = "./responses"
  api_gateway_id = aws_api_gateway_rest_api.external_api_gw_external.id
  resource_id    = aws_api_gateway_resource.transferenciasya_status_resource.id
  http_method    = aws_api_gateway_method.transferenciasya_status_post_method.http_method
  name           = "Status"
}

// Method: /v1/transfer POST

resource "aws_api_gateway_method" "transferenciasya_transfer_post_method" {
  rest_api_id          = aws_api_gateway_rest_api.external_api_gw_external.id
  resource_id          = aws_api_gateway_resource.transferenciasya_transfer_resource.id
  http_method          = "POST"
  authorization        = "COGNITO_USER_POOLS"
  authorizer_id        = aws_api_gateway_authorizer.api_gw_external_authorizer.id
  authorization_scopes = ["transferenciasya/transfer"]
}

resource "aws_api_gateway_integration" "transferenciasya_transfer_integration" {
  rest_api_id = aws_api_gateway_rest_api.external_api_gw_external.id
  resource_id = aws_api_gateway_resource.transferenciasya_transfer_resource.id
  http_method = aws_api_gateway_method.transferenciasya_transfer_post_method.http_method
  integration_http_method = "POST"
  type                    = "HTTP_PROXY"
  uri                     = "http://${var.flexibility_endpoint}/ach-endpoint/v1/transfer"
}

resource "aws_api_gateway_method" "transferenciasya_transfer_options_method" {
  rest_api_id          = aws_api_gateway_rest_api.external_api_gw_external.id
  resource_id          = aws_api_gateway_resource.transferenciasya_transfer_resource.id
  http_method          = "OPTIONS"
  authorization        = "COGNITO_USER_POOLS"
  authorizer_id        = aws_api_gateway_authorizer.api_gw_external_authorizer.id
  authorization_scopes = ["transferenciasya/transfer"]
}

resource "aws_api_gateway_integration" "transferenciasya_transfer_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.external_api_gw_external.id
  resource_id = aws_api_gateway_resource.transferenciasya_transfer_resource.id
  http_method = aws_api_gateway_method.transferenciasya_transfer_options_method.http_method
  type = "MOCK"                           # Documentation not clear
  request_templates = {                  # Not documented
    "application/json" = "{'statusCode': 200}"
  }
  passthrough_behavior = "WHEN_NO_MATCH"
}

module "transferenciasya_transfer_responses" {
  source         = "./responses"
  api_gateway_id = aws_api_gateway_rest_api.external_api_gw_external.id
  resource_id    = aws_api_gateway_resource.transferenciasya_transfer_resource.id
  http_method    = aws_api_gateway_method.transferenciasya_transfer_post_method.http_method
  name           = "Transfer"
}

// API Gateway CloudWatch policies and deployment

resource "aws_api_gateway_account" "api_gateway_account_external" {
  cloudwatch_role_arn = aws_iam_role.api_gw_cloudwatch_role.arn
}

resource "aws_api_gateway_deployment" "deployment_staging_external" {
  depends_on = ["aws_api_gateway_method.transferenciasya_credit_post_method", "aws_api_gateway_method.transferenciasya_credit_options_method", "aws_api_gateway_method.transferenciasya_debit_post_method", "aws_api_gateway_method.transferenciasya_debit_options_method", "aws_api_gateway_method.transferenciasya_status_post_method", "aws_api_gateway_method.transferenciasya_status_options_method", "aws_api_gateway_method.transferenciasya_transfer_post_method", "aws_api_gateway_method.transferenciasya_transfer_options_method", "aws_api_gateway_account.api_gateway_account"]

  rest_api_id = aws_api_gateway_rest_api.external_api_gw_external.id
  stage_name  = "staging"
  description = "External API Gateway Deployment"
}
