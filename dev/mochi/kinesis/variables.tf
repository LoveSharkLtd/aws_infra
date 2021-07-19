variable "stream_name" {
  type        = string
  description = "kinesis stream name"

}

variable "kinesis_shard_count" {
  type        = string
  description = "number of shards required for kinesis data stream"

}

variable "infra_env" {
  type        = string
  description = "infrastructure environment"

}
