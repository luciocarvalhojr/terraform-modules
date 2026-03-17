# terraform-modules

> Reusable Terraform modules for home lab infrastructure — Proxmox, Technitium DNS, MinIO, and K3s.
> Monorepo pattern inspired by CDK construct libraries. Modules are consumed directly via GitHub source references.

---

## Architecture

```
terraform-modules/
├── modules/
│   ├── proxmox-vm/     # L1 — raw VM lifecycle (clone, cloud-init, disk, CPU, tags)
│   ├── dns-record/     # L1 — Technitium DNS A + CNAME records
│   ├── minio-bucket/   # L1 — MinIO bucket with versioning + lifecycle
│   └── k3s-node/       # L3 — composition: proxmox-vm + dns-record
└── examples/
    ├── proxmox-vm/
    ├── dns-record/
    ├── minio-bucket/
    └── k3s-node/       # full K3s cluster: 1 controlplane + 3 workers
```

The CDK analogy:

| CDK | This repo |
|-----|-----------|
| L1 Construct | `proxmox-vm`, `dns-record`, `minio-bucket` |
| L3 Construct | `k3s-node` |
| CDK App | `infra-home-lab` (consumer repo) |
| `npm publish` | GitHub Release (semver tag) |
| `package.json` version | `?ref=v1.0.0` in source URL |

---

## Modules

### `proxmox-vm`

Creates a Proxmox VM by cloning a cloud-init template. Manages CPU, memory, disk, network, SSH key injection, and tags.

```hcl
module "vm" {
  source = "github.com/luciocarvalhojr/terraform-modules//modules/proxmox-vm?ref=v1.0.0"

  name           = "my-vm"
  vm_id          = 200
  proxmox_node   = "hyper01"
  template_id    = 9000
  cores          = 2
  memory         = 2048
  disk           = 20
  ip             = "192.168.0.150"
  gateway        = "192.168.0.1"
  dns_servers    = ["192.168.0.100"]
  ssh_public_key = var.ssh_public_key
  tags           = ["my-tag"]
}
```

**Outputs:** `vm_id`, `name`, `ip`, `mac_address`

---

### `dns-record`

Creates A and CNAME records in Technitium DNS. Supports multiple records per call via `for_each`.

```hcl
module "dns" {
  source = "github.com/luciocarvalhojr/terraform-modules//modules/dns-record?ref=v1.0.0"

  zone = "home.lab"

  a_records = [
    { name = "my-server", ip = "192.168.0.150" },
  ]

  cname_records = [
    { name = "app", target = "my-server.home.lab" },
  ]
}
```

**Outputs:** `a_record_names`, `cname_record_names`

**Provider config required:**
```hcl
provider "technitium" {
  host  = "http://192.168.0.x:5380"
  token = var.technitium_token
}
```

---

### `minio-bucket`

Creates a MinIO bucket using the AWS provider pointed at a MinIO endpoint. Supports versioning and noncurrent version expiration.

```hcl
module "bucket" {
  source = "github.com/luciocarvalhojr/terraform-modules//modules/minio-bucket?ref=v1.0.0"

  bucket_name                        = "terraform-state"
  versioning                         = true
  noncurrent_version_expiration_days = 90
}
```

**Outputs:** `bucket_name`, `bucket_arn`, `versioning_enabled`

**Provider config required:**
```hcl
provider "aws" {
  endpoints {
    s3 = "http://192.168.0.95:9000"
  }
  access_key                  = var.minio_access_key
  secret_key                  = var.minio_secret_key
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
}
```

---

### `k3s-node` _(composition)_

Provisions a K3s node end-to-end: creates the Proxmox VM and registers it in Technitium DNS. Optionally creates CNAME records for services running on the node.

```hcl
module "controlplane" {
  source = "github.com/luciocarvalhojr/terraform-modules//modules/k3s-node?ref=v1.2.0"

  name           = "k3s-cp-01"
  vm_id          = 200
  proxmox_node   = "hyper01"
  template_id    = 9000
  cores          = 4
  memory         = 8192
  disk           = 30
  ip             = "192.168.0.130"
  gateway        = "192.168.0.1"
  dns_servers    = ["192.168.0.100", "192.168.0.110"]
  ssh_public_key = var.ssh_public_key
  dns_zone       = "home.lab"
  tags           = ["controlplane"]

  cname_records = [
    { name = "argocd",    target = "k3s-cp-01.home.lab" },
    { name = "authentik", target = "k3s-cp-01.home.lab" },
  ]
}
```

**Outputs:** `vm_id`, `name`, `ip`, `fqdn`, `mac_address`

**Provider config required:**
```hcl
provider "proxmox" {
  endpoint  = "https://192.168.0.x:8006/"
  api_token = var.proxmox_api_token
  insecure  = true
}

provider "technitium" {
  host  = "http://192.168.0.x:5380"
  token = var.technitium_token
}
```

> **Note:** The `kenske/technitium` provider uses `host` and `token` — not `server` / `api_token`.

---

## Versioning

Modules are versioned via Git tags on this monorepo. Always pin to a tag in production:

```hcl
source = "github.com/luciocarvalhojr/terraform-modules//modules/k3s-node?ref=v1.0.0"
```

The `//` double-slash is Terraform's syntax for a subdirectory within a Git source.

Releases are automated via [semantic-release](https://github.com/semantic-release/semantic-release). Push conventional commits to `main` and the CI pipeline will determine the next version, cut the tag, and publish the GitHub Release automatically.

| Commit prefix | Version bump |
|---------------|-------------|
| `fix:` | patch (`v1.0.1`) |
| `feat:` | minor (`v1.1.0`) |
| `feat!:` / `BREAKING CHANGE` | major (`v2.0.0`) |

---

## CI

| Workflow | Trigger | What it does |
|----------|---------|--------------|
| `validate.yml` | PR + push to main | `terraform fmt -check` + `terraform validate` on all modules and examples |
| `release.yml` | Push to main | Runs semantic-release to cut a version tag and GitHub Release (dry-run on PRs) |

---

## Local development

```bash
# Pin Terraform version (uses .terraform-version via tfenv)
tfenv install
tfenv use

# Validate a specific module
terraform -chdir=modules/proxmox-vm init -backend=false
terraform -chdir=modules/proxmox-vm validate

# Format all files
terraform fmt -recursive

# Validate everything (mirrors CI)
for dir in modules/*/; do
  terraform -chdir="$dir" init -backend=false && terraform -chdir="$dir" validate
done
```

### Pre-commit hooks

```bash
# Install dependencies
brew install pre-commit tflint terraform-docs

# Install the git hook
pre-commit install

# Run against all files manually
pre-commit run --all-files

# Update hooks to latest versions
pre-commit autoupdate
```

---

## TODO — Before extracting to individual repos + Terraform Registry

This monorepo is intentionally temporary. The checklist below tracks what needs to be done
before each module is ready to be published as a standalone repo on registry.terraform.io.

### Global (applies to all modules)

- [ ] Add `terraform test` coverage for each module (`.tftest.hcl` files)
- [ ] Add `terradoc` or `terraform-docs` auto-generation to CI — keeps README inputs/outputs tables in sync
- [ ] Add `tflint` to the validate workflow for linting beyond `validate`
- [ ] Add `checkov` or `trivy` to CI for security scanning
- [ ] Add `CONTRIBUTING.md` with PR and branching conventions
- [ ] Define and document minimum provider version compatibility matrix
- [ ] Replace `count` patterns with `for_each` everywhere for safer plan diffs
- [x] Add pre-commit hooks (tflint, fmt, validate) via `.pre-commit-config.yaml`

### Per-module checklist

#### `proxmox-vm`
- [ ] Add support for multiple disks
- [ ] Add support for multiple network interfaces
- [ ] Expose `started` / `on_boot` as variables
- [ ] Add `terraform test` with a mock provider
- [ ] Harden `validation` blocks on all variables
- [ ] Decide on UEFI vs BIOS boot variable

#### `dns-record`
- [ ] Verify `kenske/technitium` provider schema matches current Technitium API version
- [ ] Add support for PTR (reverse DNS) records
- [ ] Add support for TXT records (useful for Let's Encrypt DNS-01 challenges)
- [ ] Add `terraform test` with mock provider

#### `minio-bucket`
- [ ] Add bucket policy variable (read-only, read-write, private)
- [ ] Add server-side encryption variable
- [ ] Test against MinIO CE vs MinIO Enterprise behaviour differences
- [ ] Add `terraform test`

#### `k3s-node`
- [ ] Pass `proxmox` and `technitium` provider configs explicitly (avoid implicit provider inheritance)
- [ ] Add `depends_on` between `module.vm` and `module.dns` if Technitium needs the VM to be up first
- [ ] Validate IP is within the expected subnet range
- [ ] Add `terraform test` end-to-end scenario

### Registry extraction (per module)

When a module is ready, follow these steps to publish it:

- [ ] Create repo named `terraform-<provider>-<module>` (e.g. `terraform-proxmox-vm`)
- [ ] Copy module files to repo root (not under `modules/`)
- [ ] Copy relevant example to `examples/complete/`
- [ ] Update README for standalone usage (`source = "luciocarvalhojr/<module>/<provider>"`)
- [ ] Sign in to registry.terraform.io with GitHub
- [ ] Connect the new repo under Publish → Module
- [ ] Tag `v1.0.0` — registry indexes automatically
- [ ] Update consumer repos to use registry source instead of GitHub source

### Registry extraction order (recommended)

1. `proxmox-vm` — most stable, no composition dependency
2. `dns-record` — independent, Technitium-specific
3. `minio-bucket` — independent, straightforward
4. `k3s-node` — last, depends on the above two being published first
