data "aws_ssm_parameter" "redshift_master_username" {
  name = "redshift_master_username"
}

data "aws_ssm_parameter" "redshift_master_password" {
  name = "redshift_master_password"
}

resource "aws_redshift_cluster" "mochi_redshift_cluster" {
  cluster_identifier = "mochi-prod"
  database_name      = "mochi_analytics_prod"

  master_username    = data.aws_ssm_parameter.redshift_master_username
  master_password    = data.aws_ssm_parameter.redshift_master_password

  node_type          = var.redshift_node_type
  cluster_type       = var.redshift_cluster_type
  number_of_nodes    = var.redshift_number_of_nodes

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
  value       = aws_redshift_cluster.mochi_redshift_cluster.endpoint
}

resource "aws_ssm_parameter" "redshift_port" {
  name        = "db_password"
  description = "db_password "
  type        = "SecureString"
  value       = aws_redshift_cluster.mochi_redshift_cluster.port
}

resource "aws_ssm_parameter" "redshift_db_name" {
  name        = "db_name"
  description = "db_name "
  type        = "String"
  value       = aws_redshift_cluster.mochi_redshift_cluster.database_name
}
