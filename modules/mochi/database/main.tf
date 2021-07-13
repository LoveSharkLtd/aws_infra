
########################
## Cluster
########################
resource "aws_rds_cluster" "my_sql_cluster" {

  cluster_identifier = "mochi-${var.infra_env}"
  engine             = "aurora-mysql"
  engine_version     = "5.7.mysql_aurora.2.07.3"
  availability_zones = var.azs

  database_name             = "loveshark"
  final_snapshot_identifier = "final-snapshot-mochi-${var.infra_env}"
  master_username           = local.db_creds.mysql_master_username
  master_password           = local.db_creds.mysql_master_password
  vpc_security_group_ids    = var.vpc_security_group_ids
  backup_retention_period   = 5
  preferred_backup_window   = "07:00-09:00"
  db_subnet_group_name      = aws_db_subnet_group.db_subnet_group.name

  tags = {
    Name        = "my_sql_cluster"
    ManagedBy   = "terraform"
    Environment = var.infra_env
  }

  lifecycle {
    prevent_destroy = true
  }


}

resource "aws_rds_cluster_instance" "my_sql_cluster_instances" {
  count                = 1
  identifier           = "mochi-${var.infra_env}-instance-${count.index}"
  cluster_identifier   = aws_rds_cluster.my_sql_cluster.id
  instance_class       = var.mysql_instance_class
  publicly_accessible  = true
  engine               = aws_rds_cluster.my_sql_cluster.engine
  engine_version       = aws_rds_cluster.my_sql_cluster.engine_version
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  tags = {
    Name        = "my_sql_cluster_instances"
    ManagedBy   = "terraform"
    Environment = var.infra_env
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "mochi-${var.infra_env}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name        = "My DB subnet group"
    ManagedBy   = "terraform"
    Environment = var.infra_env
  }
  lifecycle {
    prevent_destroy = true
  }
}

data "aws_kms_secrets" "creds" {
  secret {
    name    = "db"
    payload = file("db.yml.encrypted")
  }
}

locals {
  db_creds = yamldecode(data.aws_kms_secrets.creds.plaintext["db"])
}

resource "aws_ssm_parameter" "db_host" {
  name        = "db_host"
  description = "db_host "
  type        = "String"
  value       = aws_rds_cluster.my_sql_cluster.endpoint
}

resource "aws_ssm_parameter" "db_name" {
  name        = "db_name"
  description = "db_name "
  type        = "String"
  value       = aws_rds_cluster.my_sql_cluster.database_name
}

resource "aws_ssm_parameter" "db_username" {
  name        = "db_username"
  description = "db_username "
  type        = "String"
  value       = aws_rds_cluster.my_sql_cluster.master_username
}

resource "aws_ssm_parameter" "db_password" {
  name        = "db_password"
  description = "db_password "
  type        = "SecureString"
  value       = aws_rds_cluster.my_sql_cluster.master_password
}