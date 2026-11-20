# terraform-proxmox-k3s

Terraform module for provisioning a high-availability **k3s** control-plane and worker topology on **Proxmox VE** (`bpg/proxmox`), emitting a ready-to-run Ansible inventory.

- Full blueprint with Ansible Galaxy collection & Argo CD bootstrap: [`RazvanM4/k3s-proxmox-terraform-ansible`](https://github.com/RazvanM4/k3s-proxmox-terraform-ansible)
- Architecture guide: [Provision k3s with Terraform and Ansible: A Repeatable Cluster Blueprint](https://razvanmares.ro/en/blog/provision-k3s-with-terraform-and-ansible-a-repeatable-cluster-blueprint)

## Usage

```hcl
module "k3s_cluster" {
  source  = "RazvanApps/k3s/proxmox"
  version = "~> 1.0"

  cluster_name   = "homelab-ha"
  proxmox_node   = "pve-node-01"
  template_vm_id = 9000
  ssh_public_key = var.ssh_public_key
}
```
