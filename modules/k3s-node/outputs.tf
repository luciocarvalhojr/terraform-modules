output "vm_id" {
  description = "Proxmox VM ID"
  value       = module.vm.vm_id
}

output "name" {
  description = "Node hostname"
  value       = module.vm.name
}

output "ip" {
  description = "Static IP address"
  value       = module.vm.ip
}

output "fqdn" {
  description = "Fully qualified domain name"
  value       = "${var.name}.${var.dns_zone}"
}

output "mac_address" {
  description = "MAC address of the primary network interface"
  value       = module.vm.mac_address
}
