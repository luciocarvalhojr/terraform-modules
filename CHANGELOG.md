# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- `proxmox-vm` module — VM lifecycle with cloud-init, cloning, disk, CPU/memory, tags
- `dns-record` module — Technitium A and CNAME record management
- `minio-bucket` module — MinIO bucket with versioning and lifecycle
- `k3s-node` module — composition of proxmox-vm + dns-record for K3s nodes
- Examples for all modules
- GitHub Actions: validate on PR, release on semver tag
