terraform {
  required_providers {
    proxmox = {
      source = "TheGameProfi/proxmox"
      version = "2.9.15"
    }
  }
}

provider "proxmox" {
  pm_api_url = var.proxmox_api_url
  pm_user = "root@pam"
  pm_password = var.proxmox_password
  pm_tls_insecure = true
}