variable "infra_env" {
  type        = string
  description = "infrastructure environment"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "vpc_security_group_ids"
}