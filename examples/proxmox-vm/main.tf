terraform {
  required_version = ">= 1.14.7"
}

module "my_vm" {
  source = "../../modules/proxmox-vm"

  name           = "my-vm"
  vm_id          = 200
  proxmox_node   = "hyper01"
  template_id    = 9000
  cores          = 2
  memory         = 2048
  disk           = 20
  ip             = "192.168.0.150"
  gateway        = "192.168.0.1"
  dns_servers    = ["192.168.0.100", "192.168.0.110"]
  ssh_public_key = var.ssh_public_key
  tags           = ["example"]
}

variable "ssh_public_key" {
  type      = string
  sensitive = true
}

output "vm_ip" {
  value = module.my_vm.ip
}
