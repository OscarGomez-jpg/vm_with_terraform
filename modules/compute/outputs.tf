# Compute Module Outputs

output "virtual_machine_id" {
  description = "ID of the virtual machine"
  value       = azurerm_linux_virtual_machine.main.id
}

output "virtual_machine_name" {
  description = "Name of the virtual machine"
  value       = azurerm_linux_virtual_machine.main.name
}

output "virtual_machine_public_ip" {
  description = "Public IP address of the virtual machine"
  value       = azurerm_linux_virtual_machine.main.public_ip_address
}

output "virtual_machine_private_ip" {
  description = "Private IP address of the virtual machine"
  value       = azurerm_linux_virtual_machine.main.private_ip_address
}

output "network_interface_id" {
  description = "ID of the network interface"
  value       = azurerm_network_interface.main.id
}

output "network_interface_name" {
  description = "Name of the network interface"
  value       = azurerm_network_interface.main.name
}

output "auto_shutdown_schedule_id" {
  description = "ID of the auto-shutdown schedule (if enabled)"
  value       = var.enable_auto_shutdown ? azurerm_dev_test_global_vm_shutdown_schedule.main[0].id : null
}
