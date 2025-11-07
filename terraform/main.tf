terraform {
  required_version = ">= 1.13.3"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.84.1"
    }
  }
}

provider "proxmox" {
  endpoint  = var.pm_api_url
  api_token = "${var.pm_api_token_id}=${var.pm_api_token_secret}"
  insecure  = true
}

module "neutron_vm" {

  source = "../modules/proxmox_vm_template"

  providers = {
    proxmox = proxmox
  }

  vm_count            = 1
  vm_template_id      = 9001
  vm_disk0_size       = 100
  vm_cpu_cores        = 3
  vm_memory           = 10240
  vm_name_prefix      = "neutron"
  vm_baseid           = 9090
  vm_ip_start         = 90
  project_description = "VM for neutron project - All Docker apps"

}
