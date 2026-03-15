resource "technitium_dns_zone_record" "a" {
  for_each = { for r in var.a_records : r.name => r }

  zone       = var.zone
  domain     = each.value.name
  type       = "A"
  ttl        = each.value.ttl
  ip_address = each.value.ip
}

resource "technitium_dns_zone_record" "cname" {
  for_each = { for r in var.cname_records : r.name => r }

  zone   = var.zone
  domain = each.value.name
  type   = "CNAME"
  ttl    = each.value.ttl
  cname  = each.value.target
}
