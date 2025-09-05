terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # do NOT pin a version here; let the root control versions
    }
  }
}

resource "aws_route53_health_check" "primary" {
  ip_address        = var.primary_ip
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30
}

resource "aws_route53_health_check" "secondary" {
  ip_address        = var.secondary_ip
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30
}

resource "aws_route53_record" "failover_primary" {
  zone_id        = var.zone_id
  name           = var.record_name
  type           = "A"
  set_identifier = "primary"
  failover_routing_policy {
    type = "PRIMARY"
  }
  ttl             = 60
  records         = [var.primary_ip]
  health_check_id = aws_route53_health_check.primary.id
}

resource "aws_route53_record" "failover_secondary" {
  zone_id        = var.zone_id
  name           = var.record_name
  type           = "A"
  set_identifier = "secondary"
  failover_routing_policy {
    type = "SECONDARY"
  }
  ttl             = 60
  records         = [var.secondary_ip]
  health_check_id = aws_route53_health_check.secondary.id
}
