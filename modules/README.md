# Proxmox VM Terraform Module

Ce module Terraform permet de créer une ou plusieurs machines virtuelles dans un cluster **Proxmox VE**, à partir d'un template cloné.

[toc]

## 📦 Fonctionnalités

- Clonage d’un template Proxmox existant
- Configuration IP statique
- Paramétrage CPU, RAM, disque, etc.
- Génération d’une ou plusieurs VMs dynamiquement

## 🔧 Variables principales

| Nom                     | Description                        | Type   | Requis | Valeur par défaut  |
| ----------------------- | ---------------------------------- | ------ | ------ | ------------------- |
| `vm_count`            | Nombre de VMs à créer            | number | oui    | `1`               |
| `vm_template_id`      | ID du template source              | number | oui    |                     |
| `vm_disk0_size`       | Taille du disque principal (en Go) | number | oui    |                     |
| `vm_disk0_storage`    | Nom du storage Proxmox             | string | oui    | `"local-lvm"`     |
| `vm_cpu_cores`        | Nombre de cœurs CPU               | number | oui    | `1`               |
| `vm_memory`           | RAM allouée en Mo                 | number | oui    | `2048`            |
| `vm_name_prefix`      | Préfixe pour le nom des VMs       | string | oui    | `"generic-vm"`    |
| `vm_baseid`           | ID de base (chaque VM = baseid+n)  | number | oui    |                     |
| `vm_ip_start`         | Dernier octet de la première IP   | number | oui    |                     |
| `vm_gateway`          | Adresse IP de la gateway           | string | oui    | `"192.168.1.254"` |
| `vm_netmask`          | Masque réseau                     | string | oui    | `"24"`            |
| `vm_target_node`      | Nom du noeud Proxmox               | string | oui    | `"pve"`           |
| `project_description` | Description du projet              | string | non    | `"Vm for gitlab"` |

## 🔐 Authentification API

**API token** :

```hcl
export TF_VAR_pm_api_url="https://x.x.x.x:8006/api2/json/"
export TF_VAR_pm_api_token_id="terraform@pve!api"
export TF_VAR_pm_api_token_secret="votre_secret"
```

## Exemple d’utilisation

```json
module "my_vm" {
  source = "../modules/proxmox_vm_template"
  vm_count = 2
  vm_template_id = 9001
  ...
}

```

## 📤 Output

* `vm_ips_output` : liste des IPs attribuées
