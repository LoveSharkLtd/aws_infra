variable "stream_name" {
  type        = string
  description = "kinesis stream_name"

}

variable "telemetry_bucket_arn" {
  type        = string
  description = "telemetry_bucket_arn  "
}


variable "kinesis_shard_count" {
  type        = string
  description = "kinesis_shard_count number of shard count required for kinesis data stream"

}