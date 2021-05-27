output "mysql_master_password" {
    value = aws_rds_cluster.my_sql_cluster.master_password
  
}