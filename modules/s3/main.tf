resource "aws_s3_bucket" "mochi_assets" {
  bucket = "mochi-${var.infra_env}-assets"

  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = true
  }
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET","PUT", "POST"]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_policy" "mochi_assets_policy" {
  bucket = aws_s3_bucket.mochi_assets.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Sid       = ""
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:Get*"
        Resource = "${aws_s3_bucket.mochi_assets.arn}/*"
        
      },
    ]
  })
}

resource "aws_ssm_parameter" "mochi_assets_bucket" {
  name        = "mochi_assets_bucket"
  description = "mochi_assets_bucket "
  type        = "String"
  value       = aws_s3_bucket.mochi_assets.bucket
}