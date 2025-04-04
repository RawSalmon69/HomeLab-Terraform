variable "proxmox_password" {
  description = "Password for Proxmox root user"
  type        = string
  sensitive   = true
}

variable "ssh_key" {
  description = "Your public SSH key for VM access"
  type        = string
}

variable "proxmox_node" {
  description = "Proxmox node name"
  default     = "pve"
  type        = string
}

variable "vm_network" {
  description = "VM network details"
  type        = object({
    gateway = string
    subnet_mask = string
    master_ip = string
    worker_ips = list(string)
  })
  default = {
    gateway = "192.168.1.1"
    subnet_mask = "24"
    master_ip = "192.168.1.50"
    worker_ips = ["192.168.1.51", "192.168.1.52"]
  }
}

variable "template_name" {
  description = "Name of existing template to clone"
  default     = "ubuntu-2404-template"
  type        = string
}

variable "template_vmid" {
  description = "VMID of existing template"
  default     = 9000
  type        = number
}