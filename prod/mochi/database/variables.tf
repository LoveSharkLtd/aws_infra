variable "infra_env" {
  type        = string
  description = "infrastructure environment"

}


variable "mysql_instance_class" {
  type        = string
  description = "instance class for mysql cluster"

}

variable "rds_cluster_instance_count" {
  type        = string
  description = "number of cluster instance for mysql cluster"

}

