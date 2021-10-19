variable "infra_env" {
  type        = string
  description = "infrastructure environment"

}

variable "redis_node_type" {
  type        = string
  description = "redis_node_type for redis instance"

}


variable "redis_nodes" {
  type        = number
  description = "redis_nodes number of redis nodes required for redis instance"

}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "vpc_security_group_ids"

}
variable "azs" {
  type        = list(string)
  description = "Availability zones"

}


variable "public_subnets" {
  type        = list(string)
  description = "subnet "
}
