output "a_record_names" {
  description = "Names of all A records created"
  value       = [for r in technitium_dns_zone_record.a : r.domain]
}

output "cname_record_names" {
  description = "Names of all CNAME records created"
  value       = [for r in technitium_dns_zone_record.cname : r.domain]
}
