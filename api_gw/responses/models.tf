resource "aws_api_gateway_model" "error-response-model" {
  rest_api_id  = var.api_gateway_id
  name         = "ErrorResponse${var.name}"
  description  = "Error response model"
  content_type = "application/json"

  schema = <<EOF
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title": "error-response-model",
  "type": "object",
  "properties": {
    "returnCode": { "type": "string" },
    "returnCodeDesc": { "type": "string" }
  }
}
EOF
}
