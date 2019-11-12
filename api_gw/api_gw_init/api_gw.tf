
// API Gateway and Lambda Authorizer

resource "aws_api_gateway_rest_api" "internal_rest_api_gw" {
  name        = var.api_gateway_name
  description = "This is API test"
}
/*
resource "aws_api_gateway_authorizer" "api_gateway_authorizer" {
  name                   = var.api_gateway_authorizer_name
  rest_api_id            = aws_api_gateway_rest_api.internal_rest_api_gw.id
  authorizer_uri         = var.api_authorizer_lambda_invoke_arn
  authorizer_credentials = var.invocation_role_arn
}
*/
// API Gateway CloudWatch policies and deployment
