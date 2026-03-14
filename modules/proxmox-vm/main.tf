resource "proxmox_virtual_environment_vm" "this" {
  name      = var.name
  node_name = var.proxmox_node
  vm_id     = var.vm_id

  clone {
    vm_id = var.template_id
    full  = true
  }

  agent {
    enabled = true # requires qemu-guest-agent in the template
  }

  cpu {
    cores = var.cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = var.datastore_id
    size         = var.disk
    interface    = "scsi0"
    discard      = "on"
    ssd          = true
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  operating_system {
    type = "l26" # Linux kernel 2.6+
  }

  initialization {
    datastore_id = var.datastore_id

    ip_config {
      ipv4 {
        address = "${var.ip}/24"
        gateway = var.gateway
      }
    }

    dns {
      servers = var.dns_servers
    }

    user_account {
      username = var.ssh_username
      keys     = [var.ssh_public_key]
    }
  }

  tags = var.tags
}
