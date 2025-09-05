variable "name_prefix" {
  description = "Prefix for the S3 bucket name"
  type        = string
}

variable "bucket_name" {
  description = "Use an existing bucket by name (skip module-generated name)"
  type        = string
  default     = null
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = null
}

# Destination bucket ARN for replication (primary side only)
variable "replication_arn" {
  description = "Destination bucket ARN for replication"
  type        = string
  default     = null
}

# IAM role that S3 assumes for replication (primary side only)
variable "replication_role_arn" {
  description = "IAM role ARN used by S3 for replication"
  type        = string
  default     = null
}
