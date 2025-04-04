module "k3s_cluster" {
  source = "./modules/k3s-cluster"
  
  proxmox_node   = var.proxmox_node
  template_name  = var.template_name
  template_vmid  = var.template_vmid
  ssh_key        = var.ssh_key
  vm_network     = var.vm_network
  
  providers = {
    proxmox = proxmox
  }
}