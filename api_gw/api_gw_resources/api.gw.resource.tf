resource "aws_api_gateway_method" "resource_method" {
  rest_api_id   = var.api_gateway_rest_api_id
  resource_id   = var.api_gateway_resource_id
  http_method   = var.api_gateway_http_method
  authorization = var.api_gateway_authorization
  authorizer_id = var.api_gateway_authorizer_id
  request_parameters = var.api_gateway_request_parameters

}

resource "aws_api_gateway_integration" "integration_method" {
  rest_api_id = var.api_gateway_rest_api_id
  resource_id = var.api_gateway_resource_id
  http_method = aws_api_gateway_method.resource_method.http_method
  uri = "http://${var.alb_endpoint}${var.uri_resource_service_name}"
  type = var.api_gateway_integration_type
  integration_http_method = var.api_gateway_method_integration_http_method   
  request_parameters = var.api_gateway_integration_request_parameters
}

resource "aws_api_gateway_method" "optionsMethod" {
  rest_api_id   = var.api_gateway_rest_api_id
  resource_id   = var.api_gateway_resource_id
  http_method   = "OPTIONS"
  authorization = var.api_gateway_authorization
  authorizer_id = var.api_gateway_authorizer_id
}

resource "aws_api_gateway_integration" "optionsMethodIntegration" {
  rest_api_id = var.api_gateway_rest_api_id
  resource_id = var.api_gateway_resource_id
  http_method = aws_api_gateway_method.optionsMethod.http_method
  type = "MOCK"                           # Documentation not clear
  request_templates = {                  # Not documented
    "application/json" = "{'statusCode': 200}"
  }
  passthrough_behavior = "WHEN_NO_MATCH"
}



