variable "stream_name" {
  type        = string
  description = "kinesis stream_name"

}

variable "kinesis_shard_count" {
  type        = string
  description = "kinesis_shard_count number of shard count required for kinesis data stream"

}

variable "infra_env" {
  type        = string
  description = "infrastructure environment"

}
