variable "proxmox_node" {
  description = "Proxmox node name"
  type        = string
}

variable "template_name" {
  description = "Name of the VM template to clone"
  type        = string
}

variable "template_vmid" {
  description = "VMID of the template to clone"
  type        = number
}

variable "ssh_key" {
  description = "SSH public key for authentication"
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
}

variable "vm_password" {
  description = "Password for VM user"
  type        = string
  sensitive   = true
  default     = "ubuntu"  # Default password, should be changed in production
}