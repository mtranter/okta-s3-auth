
data "template_file" "auth_config" {
  template = file("${path.module}/lambda-auth/auth-config.json.template")
  vars     = {
    OIDC_CLIENT_ID          = var.oidc_provider_client_id
    OIDC_CLIENT_SECRET      = var.oidc_provider_client_secret
    OIDC_BASE_URL           = "https://${var.oidc_provider_host}"
    WEBSITE_DOMAIN          = local.websiteDomain
    PRIVATE_KEY_JSON_STRING = jsonencode(tls_private_key.oidc_key.private_key_pem)
    PUBLIC_KEY_JSON_STRING  = jsonencode(tls_private_key.oidc_key.public_key_pem)
    CALLBACK_PATH           = var.callback_path
  }
}

resource "tls_private_key" "oidc_key" {
  algorithm = "RSA"
}

resource "local_file" "auth_config" {
  filename = "${path.module}/lambda-auth/config.json"
  content  = data.template_file.auth_config.rendered
}

data "archive_file" "source_code" {
  depends_on  = [
    local_file.auth_config]
  output_path = "${path.module}/auth-lambda.zip"
  type        = "zip"
  source_dir  = "${path.module}/lambda-auth/"
}


resource "aws_iam_role" "iam_for_auth_lambda" {
  name = "${var.website_bucket_name}-auth-lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "auth_lambda_policy" {
  name = "${var.website_bucket_name}-auth-lambda"
  role   = aws_iam_role.iam_for_auth_lambda.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:CreateLogGroup"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_lambda_function" "auth" {
  provider = aws.usa
  depends_on = [data.archive_file.source_code]
  function_name    = "${var.website_bucket_name}-auth"
  handler          = "index.handler"
  role             = aws_iam_role.iam_for_auth_lambda.arn
  runtime          = "nodejs14.x"
  publish          = true
  filename         = data.archive_file.source_code.output_path
  source_code_hash = data.archive_file.source_code.output_base64sha256
}