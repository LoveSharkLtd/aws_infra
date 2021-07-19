variable "infra_env" {
  type        = string
  description = "infrastructure environment"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "vpc_security_group_ids"
}

variable "redshift_node_type" {
  type        = string
  description = "type of redshift nodes in cluster"
}

variable "redshift_cluster_type" {
  type        = string
  description = "type of cluster"
}

variable "redshift_number_of_nodes" {
  type        = number
  description = "number of nodes in cluster"
}