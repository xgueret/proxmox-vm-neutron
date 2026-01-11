# Contributing to proxmox-vm-neutron

Thank you for your interest in contributing to this project!

## How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Commit Convention

We use [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` New features
- `fix:` Bug fixes
- `docs:` Documentation changes
- `refactor:` Code refactoring
- `test:` Adding tests
- `chore:` Maintenance tasks

## Development Setup

### Prerequisites

- Terraform (>= 1.13.3)
- Ansible
- Python 3.x with pip
- Pre-commit

### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/xgueret/proxmox-vm-neutron.git
   cd proxmox-vm-neutron
   ```

2. Install pre-commit hooks:
   ```bash
   pip install -r requirements.txt
   pre-commit install
   ```

3. Configure your Proxmox credentials in `terraform/terraform.tfvars`

## Code Style

- Run `pre-commit run --all-files` before committing
- Follow existing code patterns
- Use meaningful variable names
- Keep Ansible roles modular and reusable

## Ansible Guidelines

- All sensitive variables must be encrypted with Ansible Vault
- Place sensitive files in `vault/` directories
- Test playbooks with `--check` before applying

## Terraform Guidelines

- Run `terraform fmt` before committing
- Run `terraform validate` to check syntax
- Document all variables in `variables.tf`

## Questions?

Open an issue for any questions or concerns.
