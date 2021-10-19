variable "infra_env" {
  type        = string
  description = "infrastructure environment"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "VPC security group IDs"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnets"
}

variable "opensearch_instance_type" {
  type        = string
  description = "OpenSearch instance type"
}

variable "opensearch_domain_name" {
  type        = string
  description = "Name of the OpenSearch instance"
}
