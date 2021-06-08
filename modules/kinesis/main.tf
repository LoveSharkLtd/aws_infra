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

  kinesis_source_configuration{
      kinesis_stream_arn = aws_kinesis_stream.mochi_stream.arn
      role_arn = aws_iam_role.firehose_role.arn
  }
            
  extended_s3_configuration {
    bucket_arn      = var.telemetry_bucket_arn
    buffer_interval = 300
    buffer_size     = 5
    role_arn        = aws_iam_role.firehose_role.arn

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
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "firehose.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  })
  inline_policy{
    name = "kinesis_inline_policy"
    policy = jsonencode({
      "Version": "2012-10-17",
        "Statement": [
          {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
              "kinesis:DescribeStream",
              "kinesis:GetShardIterator",
              "kinesis:GetRecords",
              "kinesis:ListShards"
            ],
              "Resource": "arn:aws:kinesis:*:*:stream/${var.stream_name}"
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


