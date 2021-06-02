variable "infra_env" {
    type = string
    description = "infrastructure environment"
  
}

variable "redis_node_type" {
    type = string
    description = "redis_node_type environment"
  
}


variable "redis_nodes" {
    type = number
    description = "number of nodes"
  
}

variable "vpc_security_group_ids" {
  type = list(string)
  description = "vpc_security_group_ids environment"
  
}
variable "azs" {
    type = list(string)
    description = "Azs "
  
}


variable "public_subnets" {
    type = list(string)
    description = "subnet "
}
