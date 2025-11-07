# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Proxmox VM automation project that uses Infrastructure as Code (IaC) to provision and configure virtual machines. The project uses **Terraform** for VM provisioning and **Ansible** for service deployment and configuration.

## Architecture

### Two-Stage Deployment Pattern

All projects follow a consistent two-stage deployment:

1. **Infrastructure Provisioning (Terraform)**: Creates VMs on Proxmox using the reusable `proxmox_vm_template` module
2. **Service Configuration (Ansible)**: Installs and configures software on the provisioned VMs

### Directory Structure

```
.
├── modules/
│   └── proxmox_vm_template/     # Reusable Terraform module for VM provisioning
├── projects/
│   └── [project_name]/
│       ├── terraform/           # Project-specific Terraform config
│       │   ├── main.tf          # Uses the proxmox_vm_template module
│       │   ├── variables.tf     # Proxmox API credentials only
│       │   └── outputs.tf
│       └── ansible/
│           ├── deploy.yml       # Main playbook
│           ├── inventory.yml    # Host definitions
│           ├── group_vars/
│           │   └── [project_name]/
│           │       ├── all/     # Non-sensitive vars (encrypted via vault)
│           │       └── vault/   # Sensitive vars (must be encrypted)
│           └── roles/           # Service-specific roles
├── ansible.cfg                  # Global Ansible config (shared across projects)
└── .pre-commit-config.yaml      # Git hooks for validation
```

### Reusable Terraform Module

The `modules/proxmox_vm_template` module handles all VM creation logic:
- VM cloning from templates
- CPU, memory, and disk configuration
- Network configuration (static IP assignment)
- Cloud-init integration

Projects only need to call this module with specific parameters (see neutron example).

## Common Development Commands

### Terraform Workflow

```bash
cd projects/[project_name]/terraform

# Initialize and validate
terraform init
terraform validate
terraform fmt

# Plan and apply
terraform plan
terraform apply

# Destroy infrastructure
terraform destroy
```

### Ansible Workflow

```bash
cd projects/[project_name]/ansible

# Install required Ansible collections (first time only)
ansible-galaxy collection install -r requirements.yml

# Run full deployment
ansible-playbook deploy.yml

# Run specific roles using tags
ansible-playbook deploy.yml --tags docker
ansible-playbook deploy.yml --tags traefik,homer

# Check what would change (dry-run)
ansible-playbook deploy.yml --check

# Syntax check
ansible-playbook deploy.yml --syntax-check
```

### Ansible Vault Management

**Important**: All files in `vault/` directories MUST be encrypted before commit.

```bash
# Edit encrypted vault file
ansible-vault edit projects/[project_name]/ansible/group_vars/[project_name]/vault/main.yml

# Encrypt a new file
ansible-vault encrypt projects/[project_name]/ansible/group_vars/[project_name]/vault/new_file.yml

# View encrypted file
ansible-vault view projects/[project_name]/ansible/group_vars/[project_name]/vault/main.yml
```

Vault password location: `~/Workspace/.vault/.vault_password` (configured in `ansible.cfg`)

### Pre-commit Hooks

```bash
# Install hooks (run once after cloning)
pip install -r requirements.txt
pre-commit install

# Run manually
pre-commit run --all-files
```

Pre-commit checks:
- Shell script formatting (shfmt)
- Shell script linting (shellcheck)
- Ansible linting (ansible-lint)
- Terraform formatting and validation
- Ansible Vault encryption verification (custom hook)

## Project-Specific Notes

### Neutron Project

**Purpose**: Docker containerization platform with reverse proxy and management tools

**Key Services**:
- Traefik (reverse proxy)
- Homer (dashboard)
- Excalidraw, Planka (applications)
- PostgreSQL (database)
- Portainer Agent (container management)

**VM Specifications**:
- CPU: 3 cores
- RAM: 10240 MB (10 GB)
- Disk: 50 GB SSD
- Template ID: 9001
- VM Base ID: 9010
- IP: Derived from `vm_ip_start` parameter (neutron-10)

**Ansible Tags**: Each role has a dedicated tag for selective deployment (see `deploy.yml`)

## Configuration Requirements

### Terraform Variables

Each project's `terraform/` directory requires a `terraform.tfvars` file (not committed):

```hcl
pm_api_url           = "https://your-proxmox-server:8006/api2/json"
pm_api_token_id      = "your-user@pam!token-name"
pm_api_token_secret  = "your-token-secret"
```

### Ansible Configuration

- **Global config**: `ansible.cfg` at repository root (shared by all projects via symlinks)
- **Remote user**: `ansible` (configured in ansible.cfg)
- **SSH**: Public key authentication, connection multiplexing enabled
- **Inventory**: Each project has its own `inventory.yml` that defines hosts

## Security Considerations

1. **Never commit unencrypted vault files**: Pre-commit hook will prevent this
2. **Ansible Vault password**: Stored outside repository at `~/Workspace/.vault/.vault_password`
3. **Terraform credentials**: Use `terraform.tfvars` (git-ignored)
4. **SSH keys**: Public key authentication required for Ansible

## IP Addressing Convention

VMs use static IPs derived from the `vm_ip_start` parameter:
- VM name: `{vm_name_prefix}-{vm_ip_start + count.index}`
- IP address: `{gateway_network}.{vm_ip_start + count.index}/24`

Example: With `vm_name_prefix="neutron"` and `vm_ip_start=10`:
- VM name: `neutron-10`
- IP: `192.168.x.10/24` (x from gateway)

## Adding New Projects

1. Create project directory structure under `projects/[project_name]/`
2. Create Terraform config that calls `modules/proxmox_vm_template`
3. Create Ansible playbook with roles for service configuration
4. Create encrypted vault files for sensitive variables
5. Update top-level README.md with project description
6. Create project-specific README.md documenting services and architecture

## Testing Changes

Before committing:
1. Run `terraform validate` and `terraform fmt`
2. Run `ansible-playbook --syntax-check deploy.yml`
3. Run `pre-commit run --all-files`
4. Verify vault files are encrypted: `bash check_ansible_vault.sh projects/*/ansible/group_vars/*/vault/*`
