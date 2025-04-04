terraform {
  required_providers {
    proxmox = {
      source = "TheGameProfi/proxmox"
      version = "2.9.15"
    }
  }
}

# Create the K3s master node
resource "proxmox_vm_qemu" "k3s_master" {
  name        = "k3s-master"
  target_node = var.proxmox_node
  vmid        = 100
  
  # Clone from the template
  clone       = var.template_name
  full_clone  = true  # Full clone to avoid template modification
  
  # Compute resources
  cores       = 2
  sockets     = 1
  memory      = 4096
  
  # Disk configuration - using ZFS storage
#   disk {
#     type    = "scsi"
#     storage = "local-zfs"
#     size    = "80G"
#     slot    = 0    
#     file    = "vm-${self.vmid}-disk-0"
#   }

  # Network configuration
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
  
  # IP configuration
  ipconfig0  = "ip=${var.vm_network.master_ip}/${var.vm_network.subnet_mask},gw=${var.vm_network.gateway}"
  
  # Cloud-init config
  sshkeys    = var.ssh_key
  ciuser     = "ubuntu"
  
  # Enable QEMU agent
  agent      = 1
  
  # Start on creation
  vm_state = "running"
}

# Create K3s worker nodes
resource "proxmox_vm_qemu" "k3s_worker" {
  count       = length(var.vm_network.worker_ips)
  
  name        = "k3s-worker-${count.index + 1}"
  target_node = var.proxmox_node
  vmid        = 101 + count.index
  
  # Clone from the template
  clone       = var.template_name
  full_clone  = true
  
  # Compute resources
  cores       = 2
  sockets     = 1
  memory      = 4096
  
#   # Disk configuration
#   disk {
#     type    = "scsi"
#     storage = "local-zfs"
#     size    = "80G"
#     slot    = 0    
#     file    = "vm-${self.vmid}-disk-0" 
#   }
  
  # Network configuration
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
  
  # IP configuration 
  ipconfig0  = "ip=${var.vm_network.worker_ips[count.index]}/${var.vm_network.subnet_mask},gw=${var.vm_network.gateway}"
  
  # Cloud-init config
  sshkeys    = var.ssh_key
  ciuser     = "ubuntu"
  
  # Enable QEMU agent
  agent      = 1
  
  # Start on creation
vm_state = "running"
}