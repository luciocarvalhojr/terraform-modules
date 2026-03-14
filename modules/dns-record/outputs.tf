output "a_record_names" {
  description = "Names of all A records created"
  value       = [for r in technitium_record.a : r.name]
}

output "cname_record_names" {
  description = "Names of all CNAME records created"
  value       = [for r in technitium_record.cname : r.name]
}
