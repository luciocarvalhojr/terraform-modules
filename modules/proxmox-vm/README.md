# module: proxmox-vm

Creates a Proxmox VM by cloning a cloud-init enabled template. Manages CPU, memory, disk sizing, static IP assignment, SSH key injection, and tags.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.9.0 |
| bpg/proxmox | ~> 0.70 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `name` | VM hostname | `string` | — | yes |
| `vm_id` | Proxmox VM ID | `number` | — | yes |
| `proxmox_node` | Proxmox node name | `string` | — | yes |
| `template_id` | Template VM ID to clone | `number` | — | yes |
| `ip` | Static IPv4 address | `string` | — | yes |
| `ssh_public_key` | SSH public key (cloud-init) | `string` | — | yes |
| `cores` | CPU cores | `number` | `2` | no |
| `memory` | RAM in MB | `number` | `2048` | no |
| `disk` | Disk size in GB | `number` | `20` | no |
| `datastore_id` | Proxmox datastore | `string` | `"local-lvm"` | no |
| `gateway` | Network gateway | `string` | `"192.168.0.1"` | no |
| `dns_servers` | DNS server IPs | `list(string)` | `["1.1.1.1","8.8.8.8"]` | no |
| `ssh_username` | Cloud-init username | `string` | `"ubuntu"` | no |
| `tags` | Proxmox tags | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| `vm_id` | Proxmox VM ID |
| `name` | VM hostname |
| `ip` | Static IP address |
| `mac_address` | Primary NIC MAC address |

## Example

See [`examples/proxmox-vm/`](../../examples/proxmox-vm/main.tf).
