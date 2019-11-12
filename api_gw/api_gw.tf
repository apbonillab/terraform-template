
// API Gateway and Lambda Authorizer

resource "aws_api_gateway_rest_api" "internal_api_gw" {
  name        = var.api_gateway_name_internal
  description = "This is the internal API for lulobank"
}

resource "aws_api_gateway_authorizer" "api_gw_authorizer" {
  name                   = "internal_api_gw_authorizer"
  rest_api_id            = aws_api_gateway_rest_api.internal_api_gw.id
  authorizer_uri         = var.api_authorizer_lambda_invoke_arn
  authorizer_credentials = var.invocation_role_arn
}

// Resources

resource "aws_api_gateway_resource" "authentication_resource" {
  rest_api_id = aws_api_gateway_rest_api.internal_api_gw.id
  parent_id   = aws_api_gateway_rest_api.internal_api_gw.root_resource_id
  path_part   = "authentication"
}

// Method: /authentication POST

resource "aws_api_gateway_method" "AuthenticationPOSTMethod" {
  rest_api_id   = aws_api_gateway_rest_api.internal_api_gw.id
  resource_id   = aws_api_gateway_resource.authentication_resource.id
  http_method   = "POST"
  authorization = "NONE"
  request_models =  {
    "application/json" = aws_api_gateway_model.authentication-user-request-model.name
  }
}

resource "aws_api_gateway_integration" "AuthenticationPOSTMethodIntegration" {
  rest_api_id = aws_api_gateway_rest_api.internal_api_gw.id
  resource_id = aws_api_gateway_resource.authentication_resource.id
  http_method = aws_api_gateway_method.AuthenticationPOSTMethod.http_method
  uri = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.aws_lambda_function_api_authenticator_lambda_arn}/invocations"
  type = "AWS"                           # Documentation not clear
  integration_http_method = "POST"       # Not documented
  request_templates = {                  # Not documented
    "application/json" = <<EOF
#set($inputRoot = $input.path('$'))
{
  "payload": $input.json('$'),
  "sourceIP" : "$context.identity.sourceIp",
  "headers" : {
    #set($params = $allParams.get("header"))
    #foreach($paramName in $params.keySet())
      "$paramName": "$util.escapeJavaScript($params.get($paramName))"
      #if($foreach.hasNext),#end
    #end
  }
}
EOF
  }
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}

resource "aws_api_gateway_method" "AuthenticationOPTIONSMethod" {
  rest_api_id   = aws_api_gateway_rest_api.internal_api_gw.id
  resource_id   = aws_api_gateway_resource.authentication_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "AuthenticationOPTIONSMethodIntegration" {
  rest_api_id = aws_api_gateway_rest_api.internal_api_gw.id
  resource_id = aws_api_gateway_resource.authentication_resource.id
  http_method = aws_api_gateway_method.AuthenticationOPTIONSMethod.http_method
  type = "MOCK"                           # Documentation not clear
  request_templates = {                  # Not documented
    "application/json" = "{'statusCode': 200}"
  }
  passthrough_behavior = "WHEN_NO_MATCH"
}

module "AuthenticationPOSTMethodResponses" {
  source         = "./responses"
  api_gateway_id = aws_api_gateway_rest_api.internal_api_gw.id
  resource_id    = aws_api_gateway_resource.authentication_resource.id
  http_method    = aws_api_gateway_method.AuthenticationPOSTMethod.http_method
  name           = "Authentication"
}

// API Gateway CloudWatch policies and deployment

resource "aws_api_gateway_account" "api_gateway_account" {
  cloudwatch_role_arn = aws_iam_role.api_gw_cloudwatch_role.arn
}

resource "aws_iam_role" "api_gw_cloudwatch_role" {
  name = "api_gateway_cloudwatch_global"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "api_gw_cloudwatch_role_policy" {
  name = "default"
  role = aws_iam_role.api_gw_cloudwatch_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_api_gateway_deployment" "deployment_staging_internal" {
  depends_on = ["aws_api_gateway_method.AuthenticationPOSTMethod", "aws_api_gateway_method.AuthenticationOPTIONSMethod", "aws_api_gateway_account.api_gateway_account"]

  rest_api_id = aws_api_gateway_rest_api.internal_api_gw.id
  stage_name  = "staging"
  description = "Internal API Gateway Deployment"
}
