# module: dns-record

Creates A and CNAME records in Technitium DNS. Supports multiple records per call.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.9.0 |
| clouddns/technitium | >= 1.0.0 |

## Provider configuration

```hcl
provider "technitium" {
  server    = "http://192.168.0.x:5380"
  api_token = var.technitium_api_token
}
```

Get your API token from Technitium web UI → **Administration → Sessions → Create Token**.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `zone` | DNS zone (e.g. `home.lab`) | `string` | — | yes |
| `a_records` | A records to create | `list(object)` | `[]` | no |
| `cname_records` | CNAME records to create | `list(object)` | `[]` | no |

### `a_records` object

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `name` | `string` | — | Hostname |
| `ip` | `string` | — | IPv4 address |
| `ttl` | `number` | `300` | TTL in seconds |

### `cname_records` object

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `name` | `string` | — | Alias name |
| `target` | `string` | — | Canonical target (FQDN) |
| `ttl` | `number` | `300` | TTL in seconds |

## Outputs

| Name | Description |
|------|-------------|
| `a_record_names` | Names of all A records created |
| `cname_record_names` | Names of all CNAME records created |

## Example

See [`examples/dns-record/`](../../examples/dns-record/main.tf).
