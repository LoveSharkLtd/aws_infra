

resource "aws_cloudfront_distribution" "mochi_s3_distribution" {
  enabled         = true
  is_ipv6_enabled = true
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = false
    default_ttl            = 0
    target_origin_id       = "S3-${data.aws_ssm_parameter.mochi_assets_bucket.value}"
    viewer_protocol_policy = "allow-all"
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"

  }
  ordered_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    path_pattern           = "game/*"
    smooth_streaming       = true
    target_origin_id       = "S3-${data.aws_ssm_parameter.mochi_assets_bucket.value}"
    viewer_protocol_policy = "allow-all"
  }
  ordered_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    cached_methods         = ["GET", "HEAD"]
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    path_pattern           = "loveshark-transcoder/*"
    smooth_streaming       = true
    target_origin_id       = "S3-${data.aws_ssm_parameter.mochi_assets_bucket.value}"
    viewer_protocol_policy = "allow-all"
  }
  ordered_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"

    cached_methods         = ["GET", "HEAD"]
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    path_pattern           = "*.zip"
    smooth_streaming       = false
    target_origin_id       = "S3-${data.aws_ssm_parameter.mochi_assets_bucket.value}"
    viewer_protocol_policy = "allow-all"
  }

  origin {
    connection_attempts = 3
    connection_timeout  = 10
    domain_name         = "${data.aws_ssm_parameter.mochi_assets_bucket.value}.s3.amazonaws.com"
    origin_id           = "S3-${data.aws_ssm_parameter.mochi_assets_bucket.value}"
    origin_path         = ""
    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.mochi_assets_origin_access_identity.id}"
    }
  }
  viewer_certificate {
    acm_certificate_arn            = ""
    cloudfront_default_certificate = true
    iam_certificate_id             = ""
    minimum_protocol_version       = "TLSv1"
    ssl_support_method             = ""
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "mochi_assets_origin_access_identity" {
  comment = "access-identity-${data.aws_ssm_parameter.mochi_assets_bucket.value}.s3.amazonaws.com"
}

resource "aws_ssm_parameter" "cloud_front_base_url" {
  name        = "cloud_front_base_url"
  description = "cloud_front_base_url for mochi  "
  type        = "String"
  value       = "https://${aws_cloudfront_distribution.mochi_s3_distribution.domain_name}/"
}

data "aws_ssm_parameter" "mochi_assets_bucket" {
  name = "mochi_assets_bucket"
}




