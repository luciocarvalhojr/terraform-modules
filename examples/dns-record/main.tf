terraform {
  required_version = ">= 1.14.7"
}

module "dns" {
  source = "../../modules/dns-record"

  zone = "home.lab"

  a_records = [
    { name = "my-server", ip = "192.168.0.150" },
    { name = "db-01", ip = "192.168.0.151" },
  ]

  cname_records = [
    { name = "grafana", target = "my-server.home.lab" },
    { name = "app", target = "my-server.home.lab" },
  ]
}

output "a_records" {
  value = module.dns.a_record_names
}
