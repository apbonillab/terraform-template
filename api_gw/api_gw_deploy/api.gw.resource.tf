resource "aws_api_gateway_account" "api_gateway_cloudwatch_account" {
  cloudwatch_role_arn = aws_iam_role.api_gateway_cloudwatch_role.arn
}

resource "aws_iam_role" "api_gateway_cloudwatch_role" {
  name = var.api_gateway_cloudtwatch_name

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

resource "aws_iam_role_policy" "api_gateway_cloudwatch_role_policy" {
  name = "default"
  role = aws_iam_role.api_gateway_cloudwatch_role.id

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

resource "aws_api_gateway_deployment" "api_deployment_staging_internal" {
  depends_on = [ "aws_api_gateway_account.api_gateway_cloudwatch_account"]

  rest_api_id = var.api_gateway_rest_api_id
  stage_name  = "staging"
  description = "Internal API Gateway Deployment"
}


resource "aws_api_gateway_method_settings" "api_gateway_settings_log" {
  rest_api_id = var.api_gateway_rest_api_id
  stage_name  = aws_api_gateway_deployment.api_deployment_staging_internal.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
    data_trace_enabled = true
  }
}

