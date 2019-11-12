output "api_gateway_resource_parent_id" {
  value = aws_api_gateway_resource.main_path.id
}
output "api_gateway_path" {
  value = substr(aws_api_gateway_resource.main_path.path, 1,50)
}