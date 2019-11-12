
resource "aws_api_gateway_integration_response" "integration_response_200" {
  rest_api_id = var.api_gateway_id
  resource_id = var.resource_id
  http_method = var.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_integration_response" "integration_response_401" {
  rest_api_id = var.api_gateway_id
  resource_id = var.resource_id
  http_method = var.http_method
  status_code = "401"

  selection_pattern = ".*httpStatus\":(400|401).*"

  response_templates = {
    "application/json" = "#set ($errorMessageObj = $util.parseJson($input.path('$.errorMessage')))\n{\n   \"returnCode\" : \"$errorMessageObj.returnCode\",\n   \"returnCodeDesc\" : \"$errorMessageObj.returnCodeDesc\"\n}"
  }
}

resource "aws_api_gateway_integration_response" "integration_response_403" {
  rest_api_id = var.api_gateway_id
  resource_id = var.resource_id
  http_method = var.http_method
  status_code = "403"

  selection_pattern = ".*httpStatus\":(403).*"

  response_templates = {
    "application/json" = "#set ($errorMessageObj = $util.parseJson($input.path('$.errorMessage')))\n{\n   \"returnCode\" : \"$errorMessageObj.returnCode\",\n   \"returnCodeDesc\" : \"$errorMessageObj.returnCodeDesc\"\n}"
  }
}

resource "aws_api_gateway_integration_response" "integration_response_408" {
  rest_api_id = var.api_gateway_id
  resource_id = var.resource_id
  http_method = var.http_method
  status_code = "408"

  selection_pattern = ".*httpStatus\":(408).*"

  response_templates = {
    "application/json" = "#set ($errorMessageObj = $util.parseJson($input.path('$.errorMessage')))\n{\n   \"returnCode\" : \"$errorMessageObj.returnCode\",\n   \"returnCodeDesc\" : \"$errorMessageObj.returnCodeDesc\"\n}"
  }
}

resource "aws_api_gateway_integration_response" "integration_response_500" {
  rest_api_id = var.api_gateway_id
  resource_id = var.resource_id
  http_method = var.http_method
  status_code = "500"

  selection_pattern = ".*httpStatus\":(500).*"

  response_templates = {
    "application/json" = "#set ($errorMessageObj = $util.parseJson($input.path('$.errorMessage')))\n{\n   \"returnCode\" : \"$errorMessageObj.returnCode\",\n   \"returnCodeDesc\" : \"$errorMessageObj.returnCodeDesc\"\n}"
  }
}

resource "aws_api_gateway_integration_response" "integration_response_503" {
  rest_api_id = var.api_gateway_id
  resource_id = var.resource_id
  http_method = var.http_method
  status_code = "503"

  selection_pattern = ".*httpStatus\":(503).*"

  response_templates = {
    "application/json" = "#set ($errorMessageObj = $util.parseJson($input.path('$.errorMessage')))\n{\n   \"returnCode\" : \"$errorMessageObj.returnCode\",\n   \"returnCodeDesc\" : \"$errorMessageObj.returnCodeDesc\"\n}"
  }
}

resource "aws_api_gateway_method_response" "method_response_200" {
  rest_api_id = var.api_gateway_id
  resource_id = var.resource_id
  http_method = var.http_method

  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "true"
  }
}

resource "aws_api_gateway_method_response" "method_response_401" {
  rest_api_id = var.api_gateway_id
  resource_id = var.resource_id
  http_method = var.http_method

  status_code = "401"

  response_models = {
    "application/json" = aws_api_gateway_model.error-response-model.name
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "true"
  }
}

resource "aws_api_gateway_method_response" "method_response_403" {
  rest_api_id = var.api_gateway_id
  resource_id = var.resource_id
  http_method = var.http_method

  status_code = "403"

  response_models = {
    "application/json" = aws_api_gateway_model.error-response-model.name
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "true"
  }
}

resource "aws_api_gateway_method_response" "method_response_408" {
  rest_api_id = var.api_gateway_id
  resource_id = var.resource_id
  http_method = var.http_method

  status_code = "408"

  response_models = {
    "application/json" = aws_api_gateway_model.error-response-model.name
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "true"
  }
}

resource "aws_api_gateway_method_response" "method_response_500" {
  rest_api_id = var.api_gateway_id
  resource_id = var.resource_id
  http_method = var.http_method

  status_code = "500"

  response_models = {
    "application/json" = aws_api_gateway_model.error-response-model.name
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "true"
  }
}

resource "aws_api_gateway_method_response" "method_response_503" {
  rest_api_id = var.api_gateway_id
  resource_id = var.resource_id
  http_method = var.http_method

  status_code = "503"

  response_models = {
    "application/json" = aws_api_gateway_model.error-response-model.name
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "true"
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response_200" {
  rest_api_id = var.api_gateway_id
  resource_id = var.resource_id
  http_method = "OPTIONS"
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_method_response" "options_method_response_200" {
  rest_api_id = var.api_gateway_id
  resource_id = var.resource_id
  http_method = "OPTIONS"

  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "true"
    "method.response.header.Access-Control-Allow-Methods" = "true"
    "method.response.header.Access-Control-Allow-Origin" = "true"
  }
}
