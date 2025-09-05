variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_engine" {
  description = "Database engine (e.g. mysql, postgres)"
  type        = string
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs for the RDS instance"
  type        = list(string)
}

variable "vpc_security_ids" {
  description = "List of VPC security group IDs for the RDS instance"
  type        = list(string)
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
}

variable "name_prefix" {
  description = "Prefix for naming AWS resources"
  type        = string
}
