locals {
  all_nodes = merge(
    { for k, v in var.server_nodes : k => merge(v, { role = "server" }) },
    { for k, v in var.agent_nodes : k => merge(v, { role = "agent" }) }
  )
}

resource "proxmox_virtual_environment_vm" "k3s_node" {
  for_each = local.all_nodes

  name        = "${var.cluster_name}-${each.key}"
  node_name   = var.proxmox_node
  vm_id       = each.value.vm_id
  description = "Managed by Terraform: ${var.cluster_name} (${each.value.role})"
  tags        = ["terraform", var.cluster_name, each.value.role]
  on_boot     = true

  clone {
    vm_id = var.template_vm_id
    full  = true
  }

  agent {
    enabled = true
  }

  cpu {
    cores = each.value.cores
    type  = "host"
  }

  memory {
    dedicated = each.value.memory
  }

  disk {
    datastore_id = var.storage_pool
    interface    = "scsi0"
    size         = each.value.disk_gb
    discard      = "on"
    ssd          = true
  }

  network_device {
    bridge = var.network_bridge
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${each.value.ipv4}/${var.cidr_prefix}"
        gateway = var.gateway_ipv4
      }
    }

    dns {
      servers = var.dns_servers
    }

    user_account {
      username = var.ansible_user
      keys     = [trimspace(var.ssh_public_key)]
    }
  }
}

resource "local_file" "ansible_inventory" {
  count = var.write_ansible_inventory ? 1 : 0

  filename        = var.ansible_inventory_path
  file_permission = "0644"
  content = templatefile("${path.module}/templates/inventory.ini.tftpl", {
    ansible_user = var.ansible_user
    servers      = var.server_nodes
    agents       = var.agent_nodes
  })
}
