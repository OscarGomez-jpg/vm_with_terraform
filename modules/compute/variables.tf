# Compute Module Variables

variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
  default     = "vm-demo"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet"
  type        = string
}

variable "public_ip_id" {
  description = "ID of the public IP"
  type        = string
}

variable "network_security_group_id" {
  description = "ID of the network security group"
  type        = string
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "vm-demo"
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B1ls"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH public key for authentication (required if disable_password_authentication is true)"
  type        = string
  default     = null
}

variable "disable_password_authentication" {
  description = "Disable password authentication (use SSH keys instead)"
  type        = bool
  default     = false
}

# OS Disk Configuration
variable "os_disk_caching" {
  description = "Caching type for the OS disk"
  type        = string
  default     = "ReadWrite"
  validation {
    condition     = contains(["None", "ReadOnly", "ReadWrite"], var.os_disk_caching)
    error_message = "OS disk caching must be None, ReadOnly, or ReadWrite."
  }
}

variable "os_disk_storage_account_type" {
  description = "Storage account type for the OS disk"
  type        = string
  default     = "Standard_LRS"
  validation {
    condition     = contains(["Standard_LRS", "Premium_LRS", "StandardSSD_LRS", "UltraSSD_LRS"], var.os_disk_storage_account_type)
    error_message = "OS disk storage account type must be one of: Standard_LRS, Premium_LRS, StandardSSD_LRS, UltraSSD_LRS."
  }
}

variable "os_disk_size_gb" {
  description = "Size of the OS disk in GB"
  type        = number
  default     = 30
  validation {
    condition     = var.os_disk_size_gb >= 30 && var.os_disk_size_gb <= 4095
    error_message = "OS disk size must be between 30 and 4095 GB."
  }
}

# Image Configuration
variable "image_publisher" {
  description = "Publisher of the VM image"
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "Offer of the VM image"
  type        = string
  default     = "UbuntuServer"
}

variable "image_sku" {
  description = "SKU of the VM image"
  type        = string
  default     = "18.04-LTS"
}

variable "image_version" {
  description = "Version of the VM image"
  type        = string
  default     = "latest"
}

# VM Configuration
variable "allow_extension_operations" {
  description = "Allow extension operations on the VM"
  type        = bool
  default     = true
}

variable "patch_mode" {
  description = "Patch mode for the VM"
  type        = string
  default     = "ImageDefault"
  validation {
    condition     = contains(["ImageDefault", "AutomaticByPlatform", "AutomaticByOS"], var.patch_mode)
    error_message = "Patch mode must be ImageDefault, AutomaticByPlatform, or AutomaticByOS."
  }
}

variable "provision_vm_agent" {
  description = "Provision VM agent"
  type        = bool
  default     = true
}

# Auto-shutdown Configuration (Cost Optimization)
variable "enable_auto_shutdown" {
  description = "Enable auto-shutdown schedule for cost optimization"
  type        = bool
  default     = true
}

variable "auto_shutdown_time" {
  description = "Time for auto-shutdown (HH:MM format)"
  type        = string
  default     = "18:00"
}

variable "auto_shutdown_timezone" {
  description = "Timezone for auto-shutdown"
  type        = string
  default     = "UTC"
}

variable "auto_shutdown_notification_enabled" {
  description = "Enable notifications for auto-shutdown"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "VM-Demo"
    ManagedBy   = "Terraform"
  }
}
