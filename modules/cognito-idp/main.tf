
resource "aws_cognito_identity_pool" "mochi_cognito_idp_pool" {
  identity_pool_name               = "mochi_cognito_idp_pool"
  allow_unauthenticated_identities = true

  tags = {
    ManagedBy   = "teraform"
    environment = var.infra_env

  }

}

resource "aws_cognito_identity_pool_roles_attachment" "mochi_cognito_idp_pool_attach_role" {
  identity_pool_id = aws_cognito_identity_pool.mochi_cognito_idp_pool.id

  roles = {
    "authenticated"   = aws_iam_role.mochi_cognito_idp_auth_role.arn
    "unauthenticated" = aws_iam_role.mochi_cognito_idp_unauth_role.arn
  }

}
resource "aws_iam_role" "mochi_cognito_idp_unauth_role" {
  name = "mochi_cognito_idp_unauth_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity",
        Effect = "Allow",
        Sid    = "",
        Principal = {
          Federated = "cognito-identity.amazonaws.com"
        },
        "Condition" : {
          "StringEquals" : {
            "cognito-identity.amazonaws.com:aud" : "${aws_cognito_identity_pool.mochi_cognito_idp_pool.id}"
          },
          "ForAnyValue:StringLike" : {
            "cognito-identity.amazonaws.com:amr" : "unauthenticated"
          }
        }
      },
    ]
  })
  inline_policy {
    name = "inline_policy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "kinesis:SubscribeToShard",
            "kinesis:DecreaseStreamRetentionPeriod",
            "kinesis:PutRecords",
            "kinesis:DescribeStreamConsumer",
            "cognito-sync:*",
            "kinesis:DescribeStreamSummary",
            "kinesis:IncreaseStreamRetentionPeriod",
            "kinesis:DescribeLimits",
            "kinesis:DisableEnhancedMonitoring",
            "kinesis:StopStreamEncryption",
            "kinesis:EnableEnhancedMonitoring",
            "kinesis:CreateStream",
            "kinesis:GetShardIterator",
            "kinesis:DescribeStream",
            "kinesis:RegisterStreamConsumer",
            "kinesis:ListTagsForStream",
            "kinesis:PutRecord",
            "mobileanalytics:PutEvents",
            "kinesis:GetRecords",
            "kinesis:StartStreamEncryption"

          ],
          "Resource" : ["*"]
        }
      ]
    })
  }
  tags = {
    ManagedBy   = "teraform"
    environment = var.infra_env

  }
}

resource "aws_iam_role" "mochi_cognito_idp_auth_role" {
  name = "mochi_cognito_idp_auth_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity",
        Effect = "Allow",
        Sid    = "",
        Principal = {
          Federated = "cognito-identity.amazonaws.com"
        },
        "Condition" : {
          "StringEquals" : {
            "cognito-identity.amazonaws.com:aud" : "${aws_cognito_identity_pool.mochi_cognito_idp_pool.id}"
          }
        }
      },
    ]
  })
  inline_policy {
    name = "inline_policy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "mobileanalytics:PutEvents",
            "cognito-sync:*",
            "cognito-identity:*"
          ],
          "Resource" : ["*"]
        }
      ]
    })
  }
  tags = {
    ManagedBy   = "teraform"
    environment = var.infra_env

  }
}