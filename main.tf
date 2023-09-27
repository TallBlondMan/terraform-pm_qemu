terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.11"
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.pm_api_url
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "alma_machine" {
  # Main info
  name        = var.vm_name
  target_node = var.pve_node
  vmid        = var.vm_id
  # Cloud init info
  clone = "alma-9-template"
  full_clone = true
  cloudinit {
    user_data = file("cloud-init.cfg")
  }

  desc = "VM mantained by Terraform"
  # Might need to change as it's node specific - cluster specific with ceph installed
  # iso = "local:iso/AlmaLinux-9-GenericCloud-9.2-20230513.x86_64.qcow2"

  searchdomain = "god.de"
  nameserver   = "10.6.0.10"

  ssh_user = "root"


  memory  = 2048
  sockets = 1
  cores   = 2

  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = 61
  }

  disk {
    type    = "scsi"
    storage = "VMs"
    size    = "10G"
  }
}