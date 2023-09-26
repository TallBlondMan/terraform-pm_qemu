terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.7.4"
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.pm_api_url
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "alma_machine" {
  name        = var.vm_name
  target_node = var.pve_node
  vmid        = var.vm_id

  description = "VM mantained by Terraform"
  # Might need to change as it's node specific - cluster specific with ceph installed
  iso = "local:iso/AlmaLinux-9-latest-x86_64-boot.iso"

  memory = 2048
  socket = 1
  cores = 2
}