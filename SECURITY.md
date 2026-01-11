# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| latest  | :white_check_mark: |

## Security Measures in This Project

This project handles sensitive infrastructure credentials. The following security measures are in place:

### Credential Protection

- **Terraform credentials**: Stored in `terraform.tfvars` (git-ignored)
- **Ansible secrets**: Encrypted with Ansible Vault in `vault/` directories
- **Pre-commit hooks**: Verify that vault files are encrypted before commit

### Best Practices

- Never commit unencrypted secrets
- Use environment variables or vault for sensitive data
- Rotate credentials regularly
- Use least-privilege access for Proxmox API tokens

## Reporting a Vulnerability

If you discover a security vulnerability, please:

1. **Do not** open a public issue
2. Email the maintainer directly at the address in the repository
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)
4. Allow reasonable time for a fix before public disclosure

We take security seriously and will respond promptly to legitimate reports.

## Security Checklist for Contributors

Before submitting a PR, ensure:

- [ ] No credentials or secrets in code
- [ ] All vault files are encrypted
- [ ] No sensitive data in commit messages
- [ ] Pre-commit hooks pass
