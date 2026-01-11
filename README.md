```
 ███╗   ██╗███████╗██╗   ██╗████████╗██████╗  ██████╗ ███╗   ██╗
 ████╗  ██║██╔════╝██║   ██║╚══██╔══╝██╔══██╗██╔═══██╗████╗  ██║
 ██╔██╗ ██║█████╗  ██║   ██║   ██║   ██████╔╝██║   ██║██╔██╗ ██║
 ██║╚██╗██║██╔══╝  ██║   ██║   ██║   ██╔══██╗██║   ██║██║╚██╗██║
 ██║ ╚████║███████╗╚██████╔╝   ██║   ██║  ██║╚██████╔╝██║ ╚████║
 ╚═╝  ╚═══╝╚══════╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
```

# 🚀 Neutron - Multi-Service Platform Automation

![Stars](https://img.shields.io/github/stars/xgueret/proxmox-vm-neutron?style=social) ![Last Commit](https://img.shields.io/github/last-commit/xgueret/proxmox-vm-neutron) ![Status](https://img.shields.io/badge/Status-Active-brightgreen)

This project automates the deployment of a multi-service platform on Proxmox using Terraform for infrastructure provisioning and Ansible for service deployment and configuration.

## 🌐 Project Architecture

The project deploys a complete containerized infrastructure with the following services:

### Deployed Services

- **Portainer Agent** - Docker container management interface

### Infrastructure Stack

1. **Terraform**: VM provisioning on Proxmox
2. **Ansible**: Service installation and configuration
3. **Docker**: Containerization platform
4. **Traefik**: Service mesh and reverse proxy

## 📋 Prerequisites

- Terraform (>= 1.13.3)
- Ansible
- Proxmox account with appropriate permissions
- A Proxmox VM template (template ID 9001 by default)

## 🛠️ Usage

### 1. VM Provisioning with Terraform

1. Navigate to the `terraform/` directory
2. Create a `terraform.tfvars` file with your Proxmox credentials
3. Run:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

Example `terraform.tfvars`:

```hcl
pm_api_url           = "https://your-proxmox-server:8006/api2/json"
pm_api_token_id      = "your-user@pam!token-name"
pm_api_token_secret  = "your-token-secret"
```

**VM Configuration:**

- CPU: 3 cores
- RAM: 10240 MB (10 GB)
- Disk: 100 GB SSD
- Template ID: 9001
- VM Base ID: 9090

### 2. Service Deployment with Ansible

1. Navigate to the `ansible/` directory
2. Configure variables in:

   - `group_vars/neutron/vault/main.yml` (encrypted with ansible-vault)
   - Individual role variables in `roles/*/vars/main.yml`
3. Run the playbook:

   ```bash
   ansible-playbook deploy.yml
   ```
4. Deploy specific services using tags:

   ```bash
   # Deploy only Traefik
   ansible-playbook deploy.yml --tags traefik

   # Deploy multiple services
   ansible-playbook deploy.yml --tags "homer,planka"
   ```

### 🔑 Available Ansible Tags

- `motd` - Deploy custom MOTD with ASCII art banner
- `docker` - Install Docker and Docker Compose
- `portainer-agent` - Deploy Portainer Agent

## 🔒 Security

Sensitive files are encrypted with Ansible Vault. A pre-commit hook verifies that files in the `vault/` directory are properly encrypted.

To edit vault files:

```bash
ansible-vault edit ansible/group_vars/neutron/vault/main.yml
```

## 💻 Code Management

The project includes pre-commit configuration for:

- Shell script formatting
- Ansible syntax checking
- Terraform validation
- Ensuring sensitive files are encrypted

To install hooks:

```bash
pre-commit install
```

## 📂 File Structure

```
.
├── ansible/                      # Ansible configuration
│   ├── ansible.cfg               # Global Ansible config
│   ├── deploy.yml                # Main playbook
│   ├── inventory.yml             # Host inventory
│   ├── group_vars/
│   │   └── neutron/              # Group variables
│   │       └── vault/            # Encrypted variables
│   └── roles/                    # Ansible roles
│       ├── motd/                 # Custom MOTD banner
│       ├── docker/               # Docker installation
│       └── portainer_agent/      # Portainer Agent
├── terraform/
│   ├── main.tf                   # Terraform main configuration
│   ├── variables.tf              # Variable definitions
│   └── outputs.tf                # Output definitions
└── README.md                     # This file
```


## 👥 Contributors

- **Author**: Xavier GUERET
  [![GitHub followers](https://img.shields.io/github/followers/xgueret?style=social)](https://github.com/xgueret) [![Twitter Follow](https://img.shields.io/twitter/follow/xgueret?style=social)](https://x.com/hixmaster) [![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=flat&logo=linkedin)](https://www.linkedin.com/in/xavier-gueret-47bb3019b/)

## 👥 Contributing

Contributions are welcome! Please feel free to submit a [Pull Request](https://github.com/xgueret/proxmox-vm-neutron/pulls).

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/xgueret/proxmox-vm-neutron/blob/main/LICENSE) file for details.
