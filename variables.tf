variable "proxmox_node" {
  description = "Target Proxmox VE node name."
  type        = string
  default     = "pve-node-01"
}

variable "template_vm_id" {
  description = "Cloud-init Ubuntu/Debian base VM template ID in Proxmox VE."
  type        = number
  default     = 9000
}

variable "cluster_name" {
  description = "Cluster prefix applied to VM names and tags."
  type        = string
  default     = "k3s-homelab"
}

variable "network_bridge" {
  description = "Proxmox virtual bridge interface."
  type        = string
  default     = "vmbr0"
}

variable "gateway_ipv4" {
  description = "Default IPv4 gateway for the cluster subnet (RFC 5737 documentation CIDR by default)."
  type        = string
  default     = "192.0.2.1"
}

variable "cidr_prefix" {
  description = "Subnet mask prefix length."
  type        = number
  default     = 24
}

variable "dns_servers" {
  description = "DNS resolvers injected via cloud-init."
  type        = list(string)
  default     = ["1.1.1.1", "9.9.9.9"]
}

variable "ssh_public_key" {
  description = "SSH public key authorized for the Ansible provisioning user."
  type        = string
}

variable "ansible_user" {
  description = "Linux username created via cloud-init for Ansible automation."
  type        = string
  default     = "ops"
}

variable "storage_pool" {
  description = "Proxmox datastore ID for VM disks."
  type        = string
  default     = "local-lvm"
}

variable "server_nodes" {
  description = "Control-plane k3s nodes."
  type = map(object({
    vm_id   = number
    ipv4    = string
    cores   = number
    memory  = number
    disk_gb = number
  }))
  default = {
    "k3s-cp-01" = { vm_id = 301, ipv4 = "192.0.2.11", cores = 4, memory = 8192, disk_gb = 64 }
    "k3s-cp-02" = { vm_id = 302, ipv4 = "192.0.2.12", cores = 4, memory = 8192, disk_gb = 64 }
    "k3s-cp-03" = { vm_id = 303, ipv4 = "192.0.2.13", cores = 4, memory = 8192, disk_gb = 64 }
  }
}

variable "agent_nodes" {
  description = "Worker k3s nodes."
  type = map(object({
    vm_id   = number
    ipv4    = string
    cores   = number
    memory  = number
    disk_gb = number
  }))
  default = {
    "k3s-wk-01" = { vm_id = 311, ipv4 = "192.0.2.21", cores = 6, memory = 16384, disk_gb = 128 }
    "k3s-wk-02" = { vm_id = 312, ipv4 = "192.0.2.22", cores = 6, memory = 16384, disk_gb = 128 }
  }
}

variable "write_ansible_inventory" {
  description = "Set true to emit a rendered Ansible inventory.ini file."
  type        = bool
  default     = true
}

variable "ansible_inventory_path" {
  description = "Output path for generated Ansible inventory."
  type        = string
  default     = "./generated-inventory.ini"
}
