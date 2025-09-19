# Compute Module
# This module creates the virtual machine and associated compute resources

# Network Interface
resource "azurerm_network_interface" "main" {
  name                = "${var.name_prefix}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_id
  }

  tags = var.tags
}

# Network Interface Security Group Association
resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = var.network_security_group_id
}

# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "main" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = [azurerm_network_interface.main.id]

  # OS Disk Configuration
  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
    disk_size_gb         = var.os_disk_size_gb
  }

  # Source Image Reference
  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  # Authentication Configuration
  disable_password_authentication = var.disable_password_authentication

  # SSH Key Configuration (if password authentication is disabled)
  dynamic "admin_ssh_key" {
    for_each = var.disable_password_authentication && var.ssh_public_key != null ? [1] : []
    content {
      username   = var.admin_username
      public_key = var.ssh_public_key
    }
  }

  # Additional Configuration
  allow_extension_operations = var.allow_extension_operations
  patch_mode                 = var.patch_mode
  provision_vm_agent         = var.provision_vm_agent

  tags = var.tags
}

# Auto-shutdown schedule (cost optimization)
resource "azurerm_dev_test_global_vm_shutdown_schedule" "main" {
  count = var.enable_auto_shutdown ? 1 : 0

  virtual_machine_id = azurerm_linux_virtual_machine.main.id
  location           = var.location
  enabled            = true

  daily_recurrence_time = replace(var.auto_shutdown_time, ":", "")
  timezone              = var.auto_shutdown_timezone

  notification_settings {
    enabled = var.auto_shutdown_notification_enabled
  }
}
