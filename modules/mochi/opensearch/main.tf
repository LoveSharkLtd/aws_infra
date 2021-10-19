data "aws_region" "current" {}

data "aws_caller_identity" "current" {}


resource "aws_elasticsearch_domain" "mochi_opensearch" {
  domain_name           = var.opensearch_domain_name
  elasticsearch_version = "OpenSearch_1.0"

  cluster_config {
    instance_type            = var.opensearch_instance_type
    dedicated_master_count   = 3
    dedicated_master_enabled = true
    dedicated_master_type    = var.opensearch_instance_type
    instance_count           = 3
    warm_enabled             = false
    zone_awareness_enabled   = true
    zone_awareness_config {
      availability_zone_count = 3
    }
  }

  access_policies = jsonencode(
    {
      "Version" = "2012-10-17"
      "Statement" = [
        {
          "Action" = "es:*"
          "Effect" = "Allow"
          "Principal" = {
            "AWS" = "*"
          }
          "Resource" = "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.opensearch_domain_name}/*"
        }
      ]
    }
  )

  vpc_options {
    security_group_ids = var.vpc_security_group_ids
    subnet_ids = var.public_subnets
  }

  advanced_security_options {
    enabled = false
  }
}

resource "aws_ssm_parameter" "opensearch_endpoint" {
  name        = "opensearch_endpoint"
  type        = "String"
  value       = aws_elasticsearch_domain.mochi_opensearch.endpoint
}
