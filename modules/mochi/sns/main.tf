resource "aws_sns_platform_application" "mochi_sns_platform_application" {

  name                = var.sns_platform_application
  platform            = "APNS"
  platform_credential = data.aws_ssm_parameter.sns_platform_app_private_key.value
  platform_principal  = data.aws_ssm_parameter.sns_platform_app_certificate.value

}

resource "aws_sns_topic" "all_users" {
  name = "all-users"
}

resource "aws_ssm_parameter" "all_users_topic" {
  name = "all_users_topic"
  type = "String"
  value = aws_sns_topic.all_users.arn
}

resource "aws_ssm_parameter" "sns_platform_app_arn" {
  name        = "sns_platform_app_arn"
  description = "sns_platform_app_arn for mochi  "
  type        = "String"
  value       = aws_sns_platform_application.mochi_sns_platform_application.arn
}

data "aws_ssm_parameter" "sns_platform_app_certificate" {
  name            = "sns_platform_app_certificate"
  with_decryption = true
}


data "aws_ssm_parameter" "sns_platform_app_private_key" {
  name            = "sns_platform_app_private_key"
  with_decryption = true
}

