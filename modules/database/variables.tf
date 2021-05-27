variable "infra_env" {
    type = string
    description = "infrastructure environment"
  
}

variable "mysql_master_username" {
    type = string
    description = "mysql_master_username environment"
  
}

variable "mysql_master_password" {
    type = string
    description = "mysql_master_password environment"
  
}

variable "mysql_instance_class" {
    type = string
    description = "mysql_instance_class environment"
  
}

variable "vpc_security_group_ids" {
  type = list(string)
  description = "vpc_security_group_ids environment"
  
}
variable "azs" {
    type = list(string)
    description = "Azs "
  
}


variable "subnet_ids" {
    type = list(string)
    description = "subnet_ids "
  
}
