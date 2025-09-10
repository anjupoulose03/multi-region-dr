variable "name_prefix" {
  description = "Base name, e.g. primary-backup-bucket-<app-id> (module appends -backup-bucket-<region>)."
  type        = string
}

variable "region" {
  description = "Region string (e.g., us-east-2 or us-west-1) appended to the bucket name."
  type        = string
}

variable "enable_replication" {
  description = "Enable CRR from this (source) bucket."
  type        = bool
  default     = false
}

variable "replication_destination_bucket_arn" {
  description = "Destination bucket ARN (arn:aws:s3:::<bucket-name>) when enable_replication=true."
  type        = string
  default     = null
}

variable "replication_role_arn" {
  description = "IAM role ARN used by S3 replication when enable_replication=true."
  type        = string
  default     = null
}

variable "tags" {
  description = "Extra tags."
  type        = map(string)
  default     = {}
}
