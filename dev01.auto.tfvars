# Vernify dev01 configuration

vm_name          = "dev01"
proxmox_node     = "pve08"
vm_cores         = 4
vm_memory        = 8192
disk_size        = 40
proxmox_datastore = "local-lvm"
network_bridge   = "vmbr0"
template_name    = "ubuntu-24.04-template"
ci_user          = "ubuntu"

# SSH access
ssh_public_keys = [
  "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBHBONYUsAucJJGHF+ZCX/ikkvdxdm6beeqKGK/ctw1+1JqApjaAcYspGWehW7vmqkyeM+GuUm5qgi7+hHqDKAjE= wernervandermerwe@Werners-Laptop.local"
]

# Temporary password for debugging (cloud-init network config issues)
ci_password = "vernify2026"

# Static IP for Postgres testing
ipv4_address  = "192.168.22.50/24"
ipv4_gateway  = "192.168.22.1"
search_domain = "vernify.com"

# VM tags for Proxmox organization
tags = ["vernify", "dev"]
