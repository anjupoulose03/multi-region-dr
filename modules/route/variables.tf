variable "zone_id" {
  description = "Route 53 Hosted Zone ID"
  type        = string
}

variable "record_name" {
  description = "The DNS record name (e.g., app.example.com)"
  type        = string
}

variable "primary_ip" {
  description = "Primary EC2 instance public IP"
  type        = string
}

variable "secondary_ip" {
  description = "Secondary EC2 instance public IP"
  type        = string
}
