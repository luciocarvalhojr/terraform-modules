# CLAUDE.md

## Current State

- **Version**: v1.2.1 (latest release, March 2026)
- **Terraform**: pinned at 1.14.7, requires >= 1.9.0
- **Modules**: 4 in production use — `proxmox-vm`, `dns-record`, `minio-bucket`, `k3s-node`
- **Distribution**: consumed via GitHub source refs (not Terraform Registry); monorepo, not extracted yet
- **Pipeline**: two workflows — `validate.yml` (fmt, validate, tflint, checkov, terraform-docs) and `release.yml` (semantic-release with floating tags v1, v1.2)
- **Deployed**: home lab use; no automated deployment — modules are consumed by external callers

## In Progress

- Nothing currently in progress. All recent work (`feat/devsecops-processus`) has been merged to main.

## Known Issues

- No `terraform test` coverage — zero `.tftest.hcl` files exist
- `proxmox-vm`: network bridge hardcoded to `vmbr0` (no variable)
- `minio-bucket`: uses `count` instead of `for_each` for conditional resources (plan diffs are noisier)
- `k3s-node`: no explicit `depends_on` between VM and DNS resources; provider passing is implicit
- `checkov` runs in soft-fail mode — security failures do not block PRs
- Technitium provider had repeated field-name confusion (`host`/`token` vs `server`/`api_token`) — fixed, but provider schema not formally documented

## Next Steps

- Add `terraform test` (`.tftest.hcl`) for each module
- Extract modules to individual repos for Terraform Registry publication (order: proxmox-vm → dns-record → minio-bucket → k3s-node)
- Replace `count`-based conditionals with `for_each` in `minio-bucket`
- Add CONTRIBUTING.md and provider version compatibility matrix
- Make checkov a hard-fail (remove `--soft-fail`) once baseline violations are addressed
- Add PTR/TXT record support to `dns-record`
- Add `on_boot`, `started`, multiple-disk, and UEFI/BIOS variables to `proxmox-vm`

## Key Decisions

- **Monorepo over individual repos**: modules share a single release cycle for now; registry extraction is planned but deferred
- **Semantic-release with floating tags**: consumers can pin to `v1` or `v1.2` for auto-patch/minor updates, or lock to `v1.2.1` for full stability
- **L1/L3 module hierarchy**: primitive modules (proxmox-vm, dns-record, minio-bucket) are composed by L3 modules (k3s-node); no L2 layer
- **`for_each` preferred over `count`**: dns-record uses `for_each` for safe plan diffs; minio-bucket still uses `count` (tech debt)
- **AWS provider for MinIO**: S3-compatible endpoint — keeps the module portable if real S3 is ever substituted
- **Pre-commit as first gate**: full lint/security/docs suite runs locally before CI; CI mirrors the same checks to catch any bypasses
