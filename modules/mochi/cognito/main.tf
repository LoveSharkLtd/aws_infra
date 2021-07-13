
resource "aws_iam_role" "sns_cognito_role" {
  name = "mochi-${var.infra_env}-cognito-sns"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Sid    = "",
        Principal = {
          Service = "cognito-idp.amazonaws.com"
        },
        "Condition" : {
          "StringEquals" : {
            "sts:ExternalId" : "sns_cognito_role_external_id"
          }
        }
      },
    ]
  })
  inline_policy {
    name = "sns_inline_policy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "sns:publish"
          ],
          "Resource" : [
            "*"
          ]
        }
      ]
    })
  }
  tags = {
    ManagedBy   = "teraform"
    environment = var.infra_env

  }
}


resource "aws_iam_role" "sns_sms_successfeedback_role" {
  name = "mochi-${var.infra_env}-sns-sms-successfeedback"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Sid    = "",
        Principal = {
          Service = "sns.amazonaws.com"
        }
      },
    ]
  })
  inline_policy {
    name = "sns_success_feedback_policy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:PutMetricFilter",
            "logs:PutRetentionPolicy"
          ],
          "Resource" : [
            "*"
          ]
        }
      ]
    })
  }
  tags = {
    ManagedBy   = "terraform"
    environment = var.infra_env

  }
}

resource "aws_sns_sms_preferences" "update_sms_prefs" {
  monthly_spend_limit                   = var.sms_monthly_dollar_limit
  delivery_status_iam_role_arn          = aws_iam_role.sns_sms_successfeedback_role.arn
  default_sms_type                      = "Transactional"
  default_sender_id                     = "MOCHI"
  delivery_status_success_sampling_rate = 0

}

resource "aws_cognito_user_pool" "mochi-userpool" {
  name                     = "mochi-${var.infra_env}"
  username_attributes      = ["email", "phone_number"]
  mfa_configuration        = "OPTIONAL"
  auto_verified_attributes = ["phone_number"]
  sms_verification_message = "Your MOCHI verification code is {####}"
  sms_configuration {
    external_id    = "sns_cognito_role_external_id"
    sns_caller_arn = aws_iam_role.sns_cognito_role.arn
  }
  account_recovery_setting {

    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 1
    }
    recovery_mechanism {
      name     = "verified_email"
      priority = 2
    }
  }
  username_configuration {
    case_sensitive = true
  }
  password_policy {
    minimum_length                   = 8
    require_symbols                  = false
    require_numbers                  = true
    require_lowercase                = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = false
    name                     = "preferred_username"
    required                 = true
    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }

  }



  schema {
    attribute_data_type      = "String"
    name                     = "email"
    required                 = false
    developer_only_attribute = false
    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }

  }

  schema {
    attribute_data_type      = "String"
    name                     = "phone_number"
    required                 = false
    developer_only_attribute = false
    mutable                  = false
    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }

  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "old_sub"
    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }

  }

  device_configuration {
    device_only_remembered_on_user_prompt = false
  }

  lifecycle {
    prevent_destroy = true
  }

}

resource "aws_cognito_user_pool_client" "mochi_ios_client" {
  name                          = "mochi-${var.infra_env}-ios_client"
  user_pool_id                  = aws_cognito_user_pool.mochi-userpool.id
  explicit_auth_flows           = ["ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_USER_PASSWORD_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  prevent_user_existence_errors = "ENABLED"
  generate_secret               = true
}



resource "aws_ssm_parameter" "cognito_pool_id" {
  name        = "cognito_pool_id"
  description = "cognito_pool_id for mochi user "
  type        = "String"
  value       = aws_cognito_user_pool.mochi-userpool.id
}

resource "aws_ssm_parameter" "cognito_app_client_id" {
  name        = "cognito_app_client_id"
  description = "cognito_app_client_id "
  type        = "String"
  value       = aws_cognito_user_pool_client.mochi_ios_client.id
}

