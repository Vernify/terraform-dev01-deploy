output "dev01_ipv4_address" {
  description = "dev01's IPv4 address — put this in mosaic-infra/inventories/sandbox/hosts.yml to run the Postgres role against it."
  value       = module.dev01.ipv4_address
}

output "dev01_vm_id" {
  description = "dev01's Proxmox VMID."
  value       = module.dev01.vm_id
}
