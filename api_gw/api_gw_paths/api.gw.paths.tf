resource "aws_api_gateway_resource" "main_path" {
  rest_api_id = var.api_gateway_rest_api_id
  parent_id   = var.api_gateway_parent_id
  path_part   = var.api_gateway_path_part
}
