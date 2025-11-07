resource "github_repository" "vm_neutron_repo" {
  name        = "proxmox-vm-neutron"
  description = "Repository to manage Proxmox VMs for Neutron project"
  visibility  = "private"
  auto_init   = false # pas besoin d'initialiser automatiquement
}