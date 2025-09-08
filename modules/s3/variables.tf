variable "name_prefix" {
  description = "Prefix for the S3 bucket name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "replication_arn" {
  description = "ARN of the destination bucket for replication"
  type        = string
}
