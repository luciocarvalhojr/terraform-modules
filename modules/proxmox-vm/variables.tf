variable "name" {
  description = "VM hostname"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "Name must be lowercase alphanumeric with hyphens only."
  }
}

variable "vm_id" {
  description = "Proxmox VM ID (must be unique per cluster)"
  type        = number
}

variable "proxmox_node" {
  description = "Proxmox node name where the VM will be created"
  type        = string
}

variable "template_id" {
  description = "Proxmox VM template ID to clone from (Ubuntu 24.04 cloud image)"
  type        = number
}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "memory" {
  description = "RAM in MB"
  type        = number
  default     = 2048
}

variable "disk" {
  description = "Disk size in GB"
  type        = number
  default     = 20
}

variable "datastore_id" {
  description = "Proxmox datastore for disk and cloud-init"
  type        = string
  default     = "local-lvm"
}

variable "ip" {
  description = "Static IPv4 address (without prefix length)"
  type        = string
  validation {
    condition     = can(cidrhost("${var.ip}/24", 0))
    error_message = "Must be a valid IPv4 address."
  }
}

variable "gateway" {
  description = "Network gateway"
  type        = string
  default     = "192.168.0.1"
}

variable "dns_servers" {
  description = "List of DNS server IPs"
  type        = list(string)
  default     = ["1.1.1.1", "8.8.8.8"]
}

variable "ssh_username" {
  description = "Username injected via cloud-init"
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_key" {
  description = "SSH public key injected into VM via cloud-init"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "List of tags to apply to the VM"
  type        = list(string)
  default     = []
}
