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
  # For debug purpous
  pm_log_enable = true
  pm_log_file   = "terraform-plugin-proxmox4.log"
  pm_debug      = true
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}

resource "proxmox_vm_qemu" "alma_machine" {
  # Main info
  name        = var.vm_name
  target_node = var.pve_node
  vmid        = var.vm_id

  # Cloud init info
  clone      = "alma-9-template"
  full_clone = true
  boot       = "order=virtio0"
  ciuser     = "root"
  cipassword = "Pa55w0rd"
  os_type    = "cloud-init"
  ipconfig0  = "ip=10.6.1.150/24,gw=10.6.1.1"
  searchdomain = "god.de"
  nameserver   = "10.6.0.10"
  sshkeys    = <<EOF
  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDVGgW9Cd9K0to6IE59WVha6IGy2Zdy1KBicseQAQ2cHMLf+NHuj4D7KJsA6vPaOSk3Rm0SXUul/aNjq4FDMkSw8VkhxuYGLncjO5NaR63eLBOR8jE95c6SSkyHW2UkYPSCNv1ORnFAdJmEq/QFCel4rNd5kXbeAjJG3l44nV7ktKgYH6tXmiqhpzd4VQkHQ+BzGyjcATtjHMBlML3kIGKpNh9NJ9O+QHzJeMv0TnEhJFNg67E7PiQyhBPsQrC9UjAcKp+eucJ5ZU2xz2obEB3OkPoEnCSinqNYAJDJ2qk7WfLfz89UjiVxQ7SjKyXjtEmEwWmNbX5BBG/DOBAT9LvMKpiIXZn0n+Evzl88HIbvIwtChaQ0dC9ibKc9j5TyxhLA2FYCcVvmZqJbYP5SDNaY4H6ibErqEIJkqH+pV+x8olsOANdX8gpOX7+QxxGoMwhYkwQ5Wr6AwMw/SU1Z3Km4zJyeU1V4bm/1tAPvKoBNT5xnxxQOjB3fgc4qBVqJAQ0= god\msmet@godex-win-015
  EOF

  # cicustom = file("cloud-init.cfg")

  desc = "VM mantained by Terraform"

  # Hardware for machine
  memory  = "4096"
  sockets = "2"
  cores   = "2"
  agent   = 1

  #Main network connection
  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = 61
  }

  # Additional 10GB disk
  disk {
    type    = "scsi"
    storage = "VMs"
    size    = "10G"
  }
}