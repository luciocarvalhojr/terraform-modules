locals {
  dns_zone     = "home.lab"
  proxmox_node = "hyper01"
  template_id  = 9000
  gateway      = "192.168.0.1"
  dns_servers  = ["192.168.0.100", "192.168.0.110"]

  workers = {
    "k3s-worker-01" = { vm_id = 201, ip = "192.168.0.131" }
    "k3s-worker-02" = { vm_id = 202, ip = "192.168.0.132" }
    "k3s-worker-03" = { vm_id = 203, ip = "192.168.0.133" }
  }
}

# ── Control plane ──────────────────────────────────────────────────────────────

module "k3s_controlplane" {
  source = "../../modules/k3s-node"

  name           = "k3s-cp-01"
  vm_id          = 200
  proxmox_node   = local.proxmox_node
  template_id    = local.template_id
  cores          = 4
  memory         = 8192
  disk           = 30
  ip             = "192.168.0.130"
  gateway        = local.gateway
  dns_servers    = local.dns_servers
  ssh_public_key = var.ssh_public_key
  dns_zone       = local.dns_zone
  tags           = ["controlplane"]

  cname_records = [
    { name = "argocd", target = "k3s-cp-01.home.lab" },
    { name = "authentik", target = "k3s-cp-01.home.lab" },
    { name = "observatory", target = "k3s-cp-01.home.lab" },
  ]
}

# ── Workers ────────────────────────────────────────────────────────────────────

module "k3s_workers" {
  source   = "../../modules/k3s-node"
  for_each = local.workers

  name           = each.key
  vm_id          = each.value.vm_id
  proxmox_node   = local.proxmox_node
  template_id    = local.template_id
  cores          = 2
  memory         = 4096
  disk           = 20
  ip             = each.value.ip
  gateway        = local.gateway
  dns_servers    = local.dns_servers
  ssh_public_key = var.ssh_public_key
  dns_zone       = local.dns_zone
  tags           = ["worker"]
}

# ── Variables ──────────────────────────────────────────────────────────────────

variable "ssh_public_key" {
  description = "SSH public key injected into all nodes via cloud-init"
  type        = string
  sensitive   = true
}

# ── Outputs ────────────────────────────────────────────────────────────────────

output "controlplane_fqdn" {
  value = module.k3s_controlplane.fqdn
}

output "controlplane_ip" {
  value = module.k3s_controlplane.ip
}

output "worker_ips" {
  value = { for k, v in module.k3s_workers : k => v.ip }
}
