resource "aws_iam_policy" "lambda-api-policy" {
  name        = "lambda-api-policy"
  path        = "/"
  description = "IAM Policy for Lambda"

  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [{
		"Action": [
			"logs:CreateLogGroup",
			"logs:CreateLogStream",
			"logs:PutLogEvents"
		],
		"Resource": "arn:aws:logs:us-east-1:680763698946:*",
		"Effect": "Allow"
	}]
}
EOF
}

resource "aws_iam_role" "lambda-api" {
  name = "lambda-api"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_lambda_function" "Lambda_API" {
  filename      = "LambdaAPI.zip"
  function_name = "lambda_api"
  role          = aws_iam_role.lambda-api.arn
  handler       = "lambda_handler"
  runtime       = "python3.8"
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda-api.name
  policy_arn = aws_iam_policy.lambda-api-policy.arn
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.Lambda_API.function_name
  principal     = "apigateway.amazonaws.com"


  source_arn = "arn:aws:execute-api:us-east-1:680763698946:aws_api_gateway_rest_api.api.id/*/aws_api_gateway_method.api-method.http_methodaws_api_gateway_resource.api-gw.path"
}

resource "aws_api_gateway_rest_api" "api" {
  name = "api"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "api-gw" {
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "path"
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "api-method" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.api-gw.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_integration" "api-int" {
  http_method             = aws_api_gateway_method.api-method.http_method
  resource_id             = aws_api_gateway_resource.api-gw.id
  rest_api_id             = aws_api_gateway_rest_api.api.id
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.Lambda_API.invoke_arn
}

resource "aws_api_gateway_deployment" "api-dep" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.api-gw.id,
      aws_api_gateway_method.api-method.id,
      aws_api_gateway_integration.api-int.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "gw-stage" {
  deployment_id = aws_api_gateway_deployment.api-dep.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "stage-api"
}
