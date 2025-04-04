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
  full_clone  = true
  
  # Compute resources
  cores       = 2
  sockets     = 1
  memory      = 4096
  
  # Network configuration
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
  
  # Cloud-init specific settings
  os_type    = "cloud-init"
  ipconfig0  = "ip=${var.vm_network.master_ip}/${var.vm_network.subnet_mask},gw=${var.vm_network.gateway}"
  nameserver = "1.1.1.1 8.8.8.8"
  searchdomain = "local"
  
  # Set specific hostname for master
  ciuser     = "ubuntu"
  cipassword = var.vm_password # Need to add this to variables
  sshkeys    = var.ssh_key
  
  # Adding these cloud-init parameters to force static IP
  # This is critical for ensuring network settings are applied
  ci_wait    = 300  # Wait longer for cloud-init to complete
  
  # Additional settings to ensure proper initialization
  agent      = 1
  onboot     = true
  
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
  
  # Network configuration
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
  
  # Cloud-init specific settings
  os_type    = "cloud-init"
  ipconfig0  = "ip=${var.vm_network.worker_ips[count.index]}/${var.vm_network.subnet_mask},gw=${var.vm_network.gateway}"
  nameserver = "1.1.1.1 8.8.8.8"
  searchdomain = "local"
  
  # Set specific hostname for each worker
  ciuser     = "ubuntu"
  cipassword = var.vm_password
  sshkeys    = var.ssh_key
  
  # Adding these cloud-init parameters to force static IP
  ci_wait    = 300  # Wait longer for cloud-init to complete
  
  # Additional settings to ensure proper initialization
  agent      = 1
  onboot     = true
  
  # Start on creation
  vm_state = "running"
}