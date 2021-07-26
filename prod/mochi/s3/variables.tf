variable "infra_env" {
  type        = string
  description = "infrastructure environment"

}

variable "mochi_asset_bucket" {
  type        = string
  default     = "loveshark-prod"
  description = "bucket_name for mochi asset"

}

variable "telemetry_bucket" {
  type        = string
  default     = "mochi-telemetry-data"
  description = "telemetry_bucket for mochi asset"

}

variable "mochi_asset_bucket_region" {
  type        = string
  default     = "eu-west-1"
  description = "region for mochi bucket"

}



