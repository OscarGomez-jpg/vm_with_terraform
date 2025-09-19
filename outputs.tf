# Root Outputs Configuration
# This file defines the outputs exposed by the root module

# VM Information
output "vm_public_ip" {
  description = "Public IP address of the virtual machine"
  value       = module.compute.virtual_machine_public_ip
}

output "vm_private_ip" {
  description = "Private IP address of the virtual machine"
  value       = module.compute.virtual_machine_private_ip
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = module.compute.virtual_machine_name
}

output "vm_id" {
  description = "ID of the virtual machine"
  value       = module.compute.virtual_machine_id
}

# Network Information
output "resource_group_name" {
  description = "Name of the resource group"
  value       = module.networking.resource_group_name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = module.networking.resource_group_location
}

output "virtual_network_name" {
  description = "Name of the virtual network"
  value       = module.networking.virtual_network_name
}

output "subnet_name" {
  description = "Name of the subnet"
  value       = module.networking.subnet_name
}

output "public_ip_address" {
  description = "Public IP address"
  value       = module.networking.public_ip_address
}

# Security Information
output "network_security_group_name" {
  description = "Name of the network security group"
  value       = module.security.network_security_group_name
}

# Connection Information
output "ssh_connection_command" {
  description = "SSH connection command for the VM"
  value       = "ssh ${var.admin_username}@${module.compute.virtual_machine_public_ip}"
}

output "vm_connection_info" {
  description = "VM connection information"
  value = {
    public_ip   = module.compute.virtual_machine_public_ip
    private_ip  = module.compute.virtual_machine_private_ip
    admin_user  = var.admin_username
    ssh_command = "ssh ${var.admin_username}@${module.compute.virtual_machine_public_ip}"
  }
}

# Cost Optimization Information
output "auto_shutdown_enabled" {
  description = "Whether auto-shutdown is enabled"
  value       = var.enable_auto_shutdown
}

output "auto_shutdown_time" {
  description = "Auto-shutdown time"
  value       = var.auto_shutdown_time
  sensitive   = false
}
