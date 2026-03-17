module "vm" {
  source = "../proxmox-vm"

  name           = var.name
  vm_id          = var.vm_id
  proxmox_node   = var.proxmox_node
  template_id    = var.template_id
  cores          = var.cores
  memory         = var.memory
  disk           = var.disk
  datastore_id   = var.datastore_id
  ip             = var.ip
  gateway        = var.gateway
  dns_servers    = var.dns_servers
  ssh_username   = var.ssh_username
  ssh_public_key = var.ssh_public_key
  tags           = concat(["k3s"], var.tags)
}

module "dns" {
  source = "../dns-record"

  zone = var.dns_zone

  a_records = [
    { name = "${var.name}.${var.dns_zone}", ip = var.ip }
  ]

  cname_records = var.cname_records
}
