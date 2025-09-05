output "primary_dns_record" {
  value = aws_route53_record.failover_primary.fqdn
}

output "secondary_dns_record" {
  value = aws_route53_record.failover_secondary.fqdn
}

output "primary_health_check_id" {
  value = aws_route53_health_check.primary.id
}

output "secondary_health_check_id" {
  value = aws_route53_health_check.secondary.id
}
