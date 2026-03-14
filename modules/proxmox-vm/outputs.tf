output "vm_id" {
  description = "Proxmox VM ID"
  value       = proxmox_virtual_environment_vm.this.vm_id
}

output "name" {
  description = "VM hostname"
  value       = proxmox_virtual_environment_vm.this.name
}

output "ip" {
  description = "Static IP address assigned to the VM"
  value       = var.ip
}

output "mac_address" {
  description = "MAC address of the primary network interface"
  value       = proxmox_virtual_environment_vm.this.network_device[0].mac_address
}
