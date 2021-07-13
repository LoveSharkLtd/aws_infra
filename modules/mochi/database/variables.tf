variable "infra_env" {
  type        = string
  description = "infrastructure environment"

}


variable "mysql_instance_class" {
  type        = string
  description = "instance class for mysql cluster"

}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "vpc_security_group_ids"

}
variable "azs" {
  type        = list(string)
  description = "Azs "

}


variable "subnet_ids" {
  type        = list(string)
  description = "subnet_ids "

}
