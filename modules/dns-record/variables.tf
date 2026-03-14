variable "zone" {
  description = "DNS zone to create records in (e.g. home.lab)"
  type        = string
}

variable "a_records" {
  description = "A records to create — maps hostnames to IPv4 addresses"
  type = list(object({
    name = string
    ip   = string
    ttl  = optional(number, 300)
  }))
  default = []
}

variable "cname_records" {
  description = "CNAME records to create — maps aliases to canonical names"
  type = list(object({
    name   = string
    target = string
    ttl    = optional(number, 300)
  }))
  default = []
}
