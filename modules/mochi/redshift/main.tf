data "aws_ssm_parameter" "redshift_master_username" {
  name = "redshift_master_username"
}

data "aws_ssm_parameter" "redshift_master_password" {
  name = "redshift_master_password"
}

resource "aws_redshift_cluster" "mochi_redshift_cluster" {
  cluster_identifier = "mochi_prod"
  database_name      = "mochi_analytics_prod"

  master_username    = data.aws_ssm_parameter.redshift_master_username
  master_password    = data.aws_ssm_parameter.redshift_master_password

  node_type          = "dc2.large"
  cluster_type       = "multi-node"
  number_of_nodes    = 8

  vpc_security_group_ids = var.vpc_security_group_ids

  tags = {
    Name        = "mochi_redshift_cluster"
    ManagedBy   = "terraform"
    Environment = var.infra_env
  }
  
  lifecycle {
    prevent_destroy = true
  }
}


resource "aws_ssm_parameter" "redshift_host" {
  name        = "db_host"
  description = "db_host "
  type        = "String"
  value       = mochi_redshift_cluster.mochi_prod.endpoint
}

resource "aws_ssm_parameter" "redshift_port" {
  name        = "db_password"
  description = "db_password "
  type        = "SecureString"
  value       = mochi_redshift_cluster.mochi_prod.port
}

resource "aws_ssm_parameter" "redshift_db_name" {
  name        = "db_name"
  description = "db_name "
  type        = "String"
  value       = mochi_redshift_cluster.mochi_prod.database_name
}
