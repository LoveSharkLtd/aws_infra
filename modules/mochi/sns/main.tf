resource "aws_iam_role" "push_notification_delivery_report_role" {
  name = "push_notification_delivery_report_role"

  assume_role_policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "sns.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    }
  )
  inline_policy {
    name = "push_notification_delivery_inline_policy"
    policy = jsonencode(
      {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Action": [
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:PutLogEvents",
              "logs:PutMetricFilter",
              "logs:PutRetentionPolicy"
            ],
            "Resource": [
              "*"
            ]
          }
        ]
      }
    )
  }
  tags = {
    Name      = "push_notification_delivery_report_role"
    ManagedBy = "terraform"
  }
}

resource "aws_sns_platform_application" "mochi_sns_platform_application" {

  name                         = var.sns_platform_application
  platform                     = "APNS"
  platform_credential          = data.aws_ssm_parameter.sns_platform_app_private_key.value
  platform_principal           = data.aws_ssm_parameter.sns_platform_app_certificate.value
  success_feedback_role_arn    = aws_iam_role.push_notification_delivery_report_role.arn
  failure_feedback_role_arn    = aws_iam_role.push_notification_delivery_report_role.arn
  success_feedback_sample_rate = 100
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
