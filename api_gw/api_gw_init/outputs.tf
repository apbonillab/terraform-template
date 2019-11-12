output "api_gateway_rest_api_execution_arn" {
  value = aws_api_gateway_rest_api.internal_rest_api_gw.execution_arn
}

output "api_gateway_id" {
  value = aws_api_gateway_rest_api.internal_rest_api_gw.id
}
output "api_gateway_root_resource" {
  value = aws_api_gateway_rest_api.internal_rest_api_gw.root_resource_id
}
/*
output "api_gateway_stage_name" {
  value = aws_api_gateway_deployment.api_deployment_staging_internal.stage_name
}*/