terraform {
  required_version = ">= 1.13.3"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.84.1"
    }
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  count       = var.vm_count
  name        = "${var.vm_name_prefix}-${var.vm_ip_start + count.index}"
  description = var.project_description
  node_name   = var.vm_target_node
  vm_id       = var.vm_baseid + count.index
  tags        = ["terraform"]

  clone {
    vm_id   = var.vm_template_id
    full    = true
    retries = 5
  }

  agent {
    enabled = true
    timeout = "1s" # Don't wait for agent if permissions are missing
  }

  cpu {
    cores = var.vm_cpu_cores
    type  = "host"
  }

  memory {
    dedicated = var.vm_memory
  }

  disk {
    datastore_id = var.vm_disk0_storage
    interface    = "scsi0"
    size         = var.vm_disk0_size
    file_format  = "raw"
  }

  initialization {
    dns {
      domain  = "local"
      servers = ["1.1.1.1"]
    }

    ip_config {
      ipv4 {
        address = "${join(".", slice(split(".", var.vm_gateway), 0, 3))}.${var.vm_ip_start + count.index}/${var.vm_netmask}"
        gateway = var.vm_gateway
      }
    }
  }

  vga {
    type = "std"
  }
}

output "vm_ips_output" {
  description = "IPs of the created VMs"
  value       = [for vm in proxmox_virtual_environment_vm.vm : vm.ipv4_addresses]
}
