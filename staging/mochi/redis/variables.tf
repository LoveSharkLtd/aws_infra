variable "infra_env" {
  type        = string
  description = "infrastructure environment"

}

variable "redis_node_type" {
  type        = string
  description = "rredis_node_type for redis instance"

}

variable "redis_nodes" {
  type        = number
  description = "redis_nodes number of redis nodes required for redis instance"

}


