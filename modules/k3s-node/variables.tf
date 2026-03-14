# ── VM identity ────────────────────────────────────────────────────────────────

variable "name" {
  description = "Node hostname — used as VM name, DNS A record, and tag"
  type        = string
}

variable "vm_id" {
  description = "Proxmox VM ID (must be unique per cluster)"
  type        = number
}

# ── Proxmox ────────────────────────────────────────────────────────────────────

variable "proxmox_node" {
  description = "Proxmox node name"
  type        = string
}

variable "template_id" {
  description = "VM template ID to clone from"
  type        = number
}

variable "datastore_id" {
  description = "Proxmox datastore for disk and cloud-init"
  type        = string
  default     = "local-lvm"
}

# ── Sizing ─────────────────────────────────────────────────────────────────────

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

# ── Network ────────────────────────────────────────────────────────────────────

variable "ip" {
  description = "Static IPv4 address (without prefix length)"
  type        = string
}

variable "gateway" {
  description = "Network gateway"
  type        = string
  default     = "192.168.0.1"
}

variable "dns_servers" {
  description = "DNS server IPs injected via cloud-init"
  type        = list(string)
  default     = ["192.168.0.100", "192.168.0.110"]
}

# ── SSH / cloud-init ───────────────────────────────────────────────────────────

variable "ssh_username" {
  description = "Username injected via cloud-init"
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_key" {
  description = "SSH public key injected via cloud-init"
  type        = string
  sensitive   = true
}

# ── DNS ────────────────────────────────────────────────────────────────────────

variable "dns_zone" {
  description = "Technitium DNS zone (e.g. home.lab)"
  type        = string
}

variable "cname_records" {
  description = "Optional CNAME records pointing to this node"
  type = list(object({
    name   = string
    target = string
    ttl    = optional(number, 300)
  }))
  default = []
}

# ── Tags ───────────────────────────────────────────────────────────────────────

variable "tags" {
  description = "Additional Proxmox tags (k3s is always added automatically)"
  type        = list(string)
  default     = []
}
