terraform {
  required_version = ">= 1.9.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.70"
    }
    technitium = {
      source  = "clouddns/technitium"
      version = ">= 1.0.0"
    }
  }
}
