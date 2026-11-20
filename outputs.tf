output "server_ips" {
  description = "Map of k3s control-plane node names to IPv4 addresses."
  value       = { for k, v in var.server_nodes : k => v.ipv4 }
}

output "agent_ips" {
  description = "Map of k3s worker node names to IPv4 addresses."
  value       = { for k, v in var.agent_nodes : k => v.ipv4 }
}

output "vm_ids" {
  description = "Provisioned Proxmox VM IDs keyed by logical node name."
  value       = { for k, v in proxmox_virtual_environment_vm.k3s_node : k => v.vm_id }
}

output "ansible_inventory_path" {
  description = "Generated Ansible inventory path if write_ansible_inventory is true."
  value       = var.write_ansible_inventory ? var.ansible_inventory_path : null
}
