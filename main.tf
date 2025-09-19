# Main Terraform Configuration
# This file orchestrates the deployment of a cost-optimized Azure VM infrastructure

# Configure the Azure Provider
terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Configure the Azure Provider
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Networking Module
module "networking" {
  source = "./modules/networking"

  name_prefix         = var.name_prefix
  location            = var.location
  resource_group_name = var.resource_group_name

  # Network Configuration
  vnet_address_space      = var.vnet_address_space
  subnet_address_prefixes = var.subnet_address_prefixes
  public_ip_sku           = var.public_ip_sku

  tags = var.tags
}

# Security Module
module "security" {
  source = "./modules/security"

  name_prefix         = var.name_prefix
  location            = module.networking.resource_group_location
  resource_group_name = module.networking.resource_group_name

  # Security Configuration
  ssh_source_address_prefix = var.ssh_source_address_prefix
  enable_http_access        = var.enable_http_access
  enable_https_access       = var.enable_https_access
  custom_security_rules     = var.custom_security_rules

  tags = var.tags
}

# Compute Module
module "compute" {
  source = "./modules/compute"

  name_prefix         = var.name_prefix
  location            = module.networking.resource_group_location
  resource_group_name = module.networking.resource_group_name

  # Network Integration
  subnet_id                 = module.networking.subnet_id
  public_ip_id              = module.networking.public_ip_id
  network_security_group_id = module.security.network_security_group_id

  # VM Configuration
  vm_name                         = var.vm_name
  vm_size                         = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  ssh_public_key                  = var.ssh_public_key
  disable_password_authentication = var.disable_password_authentication

  # Storage Configuration
  os_disk_caching              = var.os_disk_caching
  os_disk_storage_account_type = var.os_disk_storage_account_type
  os_disk_size_gb              = var.os_disk_size_gb

  # Image Configuration
  image_publisher = var.image_publisher
  image_offer     = var.image_offer
  image_sku       = var.image_sku
  image_version   = var.image_version

  # Cost Optimization
  enable_auto_shutdown   = var.enable_auto_shutdown
  auto_shutdown_time     = var.auto_shutdown_time
  auto_shutdown_timezone = var.auto_shutdown_timezone

  tags = var.tags
}
