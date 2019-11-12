resource "aws_api_gateway_model" "authentication-user-request-model" {
  rest_api_id  = aws_api_gateway_rest_api.internal_api_gw.id
  name         = "AuthenticationUserRequest"
  description  = "Request for Authentication resource"
  content_type = "application/json"

  schema = <<EOF
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title": "authentication-user-request-model",
  "type": "object",
  "properties": {
    "username": { "type": "string" },
    "password": { "type": "string" }
  }
}
EOF
}


