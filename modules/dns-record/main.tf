resource "technitium_record" "a" {
  for_each = { for r in var.a_records : r.name => r }

  zone = var.zone
  name = each.value.name
  type = "A"
  ttl  = each.value.ttl

  a_record {
    ip_address = each.value.ip
  }
}

resource "technitium_record" "cname" {
  for_each = { for r in var.cname_records : r.name => r }

  zone = var.zone
  name = each.value.name
  type = "CNAME"
  ttl  = each.value.ttl

  cname_record {
    cname = each.value.target
  }
}
