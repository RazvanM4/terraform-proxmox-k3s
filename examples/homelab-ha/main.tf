terraform {
  required_version = ">= 1.9.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.69"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = false
}

variable "proxmox_endpoint" {
  type = string
}

variable "proxmox_api_token" {
  type      = string
  sensitive = true
}

variable "ssh_public_key" {
  type = string
}

module "k3s_cluster" {
  source = "../.."

  cluster_name   = "homelab-ha"
  proxmox_node   = "pve-node-01"
  template_vm_id = 9000
  ssh_public_key = var.ssh_public_key
}
