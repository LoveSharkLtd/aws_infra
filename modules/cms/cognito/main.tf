######## cms cognito pool 

resource "aws_cognito_user_pool" "cms-userpool" {

  name                       = "cms-${var.infra_env}"
  username_attributes        = ["email", "phone_number"]
  auto_verified_attributes   = ["email"]
  mfa_configuration          = "OFF"
  
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }

  }
  admin_create_user_config {
    allow_admin_create_user_only = true
    invite_message_template {
      email_message = "Your username is {username} and temporary password is {####}. "
      email_subject = "${var.infra_env}:Your temporary password"
      sms_message   = "Your username is {username} and temporary password is {####}. "
    }

  }

  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = false
    require_uppercase                = false
    temporary_password_validity_days = 7
  }

  schema {
    attribute_data_type          = "String"
    developer_only_attribute     = false
    mutable                      = true
    name                         = "email"
    required                     = true
    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }

  }
  schema {
    attribute_data_type          = "String"
    developer_only_attribute     = false
    mutable                      = true
    name                         = "preferred_username"
    required                     = true
    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }

  }

}


resource "aws_cognito_user_pool_client" "cms_web_client" {
  name                          = "cms-${var.infra_env}-web_client"
  user_pool_id                  = aws_cognito_user_pool.cms-userpool.id
  explicit_auth_flows           = ["ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_USER_PASSWORD_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  prevent_user_existence_errors = "ENABLED"
  supported_identity_providers  = ["COGNITO"]
  access_token_validity         = 60
  id_token_validity             = 60
  token_validity_units {
    access_token = "minutes"
    id_token = "minutes"
    refresh_token = "days"
  }
  
}



resource "aws_ssm_parameter" "cms_cognito_pool_id" {
  name        = "cms_cognito_pool_id"
  description = "cms cognito_pool_id"
  type        = "String"
  value       = aws_cognito_user_pool.cms-userpool.id
}

resource "aws_ssm_parameter" "cms_cognito_app_client_id" {
  name        = "cms_cognito_app_client_id"
  description = "cms cognito_app_client_id "
  type        = "String"
  value       = aws_cognito_user_pool_client.cms_web_client.id
}
