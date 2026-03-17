# module: k3s-node

Composition module that provisions a K3s node end-to-end: creates the Proxmox VM and registers it in Technitium DNS. Optionally creates CNAME records for services running on the node.

Internally calls:
- [`proxmox-vm`](../proxmox-vm/) — VM lifecycle
- [`dns-record`](../dns-record/) — DNS registration

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.9.0 |
| bpg/proxmox | ~> 0.70 |
| kenske/technitium | >= 0.2.2 |

## Provider configuration

Both providers must be configured in the calling root module:

```hcl
provider "proxmox" {
  endpoint = "https://192.168.0.x:8006/"
  api_token = var.proxmox_api_token
  insecure  = true
}

provider "technitium" {
  host  = "http://192.168.0.x:5380"
  token = var.technitium_token
}
```

> **Note:** The `kenske/technitium` provider uses `host` and `token` — not `server` / `api_token`.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `name` | Node hostname | `string` | — | yes |
| `vm_id` | Proxmox VM ID | `number` | — | yes |
| `proxmox_node` | Proxmox node name | `string` | — | yes |
| `template_id` | Template VM ID to clone | `number` | — | yes |
| `ip` | Static IPv4 address | `string` | — | yes |
| `ssh_public_key` | SSH public key (cloud-init) | `string` | — | yes |
| `dns_zone` | Technitium DNS zone | `string` | — | yes |
| `cores` | CPU cores | `number` | `2` | no |
| `memory` | RAM in MB | `number` | `2048` | no |
| `disk` | Disk size in GB | `number` | `20` | no |
| `datastore_id` | Proxmox datastore | `string` | `"local-lvm"` | no |
| `gateway` | Network gateway | `string` | `"192.168.0.1"` | no |
| `dns_servers` | DNS server IPs (cloud-init) | `list(string)` | `["192.168.0.100","192.168.0.110"]` | no |
| `ssh_username` | Cloud-init username | `string` | `"ubuntu"` | no |
| `cname_records` | CNAME records pointing to this node | `list(object)` | `[]` | no |
| `tags` | Additional Proxmox tags | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| `vm_id` | Proxmox VM ID |
| `name` | Node hostname |
| `ip` | Static IP address |
| `fqdn` | Fully qualified domain name |
| `mac_address` | Primary NIC MAC address |

## Example

See [`examples/k3s-node/`](../../examples/k3s-node/main.tf) for a full cluster (1 controlplane + 3 workers using `for_each`).

## Migration from `proxmox-vm`

If you previously managed a VM with the `proxmox-vm` module and want to switch to `k3s-node` without destroying and recreating the VM, use a `moved` block to migrate the Terraform state.

**Before (proxmox-vm):**

```hcl
module "my_node" {
  source = "github.com/luciocarvalhojr/terraform-modules//modules/proxmox-vm?ref=v1.1.0"
  # ...
}
```

**After (k3s-node) with state migration:**

```hcl
module "my_node" {
  source = "github.com/luciocarvalhojr/terraform-modules//modules/k3s-node?ref=v1.2.0"
  # ...
}

moved {
  from = module.my_node.proxmox_virtual_environment_vm.this
  to   = module.my_node.module.vm.proxmox_virtual_environment_vm.this
}
```

Without the `moved` block, Terraform will plan a **destroy + recreate** of the VM because the resource address changes when the source module changes.
