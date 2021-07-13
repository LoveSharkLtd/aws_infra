resource "aws_kinesis_stream" "mochi_stream" {

  name             = var.stream_name
  shard_count      = var.kinesis_shard_count
  retention_period = 48


  tags = {
    Name        = "aws_kinesis_stream replication group"
    ManagedBy   = "terraform"
    Environment = var.stream_name
  }

  lifecycle {

    prevent_destroy = true
  }

}

resource "aws_kinesis_firehose_delivery_stream" "mochi_firehose_delivery_stream" {

  name        = "${var.stream_name}-kinesis-firehose"
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.mochi_stream.arn
    role_arn           = aws_iam_role.firehose_role.arn
  }

  extended_s3_configuration {
    bucket_arn      = var.telemetry_bucket_arn
    buffer_interval = 300
    buffer_size     = 5
    role_arn        = aws_iam_role.firehose_role.arn
    cloudwatch_logging_options{
      enabled = true
      log_group_name = "/aws/kinesisfirehose/${var.stream_name}-kinesis-firehose"
      log_stream_name = "S3Delivery"
    }

  }


  tags = {
    Name        = "aws_kinesis_firehose_delivery_stream"
    ManagedBy   = "terraform"
    Environment = var.stream_name
  }

  lifecycle {

    prevent_destroy = true
  }
}



resource "aws_iam_role" "firehose_role" {
  name = "firehose_test_role"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "firehose.amazonaws.com"
          },
          "Effect" : "Allow",
          "Sid" : ""
        }
      ]
  })
  inline_policy {
    name = "kinesis_inline_policy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "S3Access",
          "Effect" : "Allow",
          "Action" : [
            "s3:AbortMultipartUpload",
            "s3:GetBucketLocation",
            "s3:GetObject",
            "s3:ListBucket",
            "s3:ListBucketMultipartUploads",
            "s3:PutObject"
          ],
          "Resource" : [
            var.telemetry_bucket_arn,
            "${var.telemetry_bucket_arn}/*"
          ]
        },
        {
          "Sid" : "kinesisAccess",
          "Effect" : "Allow",
          "Action" : [
            "kinesis:DescribeStream",
            "kinesis:GetShardIterator",
            "kinesis:GetRecords",
            "kinesis:ListShards"
          ],
          "Resource" : aws_kinesis_stream.mochi_stream.arn
        },
        {
            "Sid": "cloudwatchAccess",
            "Effect": "Allow",
            "Action": [
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:*:*:log-group:/aws/kinesisfirehose/${var.stream_name}-kinesis-firehose:log-stream:*"
            ]
        },
        {
          "Sid" : "kmsKinesisAccess",
          "Effect" : "Allow",
          "Action": [
                "kms:Decrypt",
                "kms:GenerateDataKey"
            ],
            "Resource": [
                "arn:aws:kms:eu-west-1:${data.aws_caller_identity.current.account_id}:key/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
            ],
            "Condition": {
                "StringEquals": {
                    "kms:ViaService": "kinesis.eu-west-1.amazonaws.com"
                },
                "StringLike": {
                    "kms:EncryptionContext:aws:kinesis:arn": aws_kinesis_stream.mochi_stream.arn
                }
            }
        },
        {
            "Sid": "KmsS3Access",
            "Effect": "Allow",
            "Action": [
                "kms:GenerateDataKey",
                "kms:Decrypt"
            ],
            "Resource": [
                "arn:aws:kms:eu-west-1:${data.aws_caller_identity.current.account_id}:key/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
            ],
            "Condition": {
                "StringEquals": {
                    "kms:ViaService": "s3.eu-west-1.amazonaws.com"
                },
                "StringLike": {
                    "kms:EncryptionContext:aws:s3:arn": [
                        "arn:aws:s3:::%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/*"
                    ]
                }
            }
        }
      ]

    })
  }
  tags = {
    Name        = "firehose_role"
    ManagedBy   = "terraform"
    Environment = var.stream_name
  }
}

resource "aws_ssm_parameter" "mochi_kinesis_stream_name" {
  name        = "mochi_kinesis_stream_name"
  description = "mochi_kinesis_stream_name for mochi  "
  type        = "String"
  value       = aws_kinesis_stream.mochi_stream.name
}

data "aws_caller_identity" "current" { }


