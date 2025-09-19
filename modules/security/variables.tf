# Security Module Variables

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

variable "ssh_source_address_prefix" {
  description = "Source address prefix for SSH access"
  type        = string
  default     = "*"
}

variable "enable_http_access" {
  description = "Enable HTTP access (port 80)"
  type        = bool
  default     = false
}

variable "http_source_address_prefix" {
  description = "Source address prefix for HTTP access"
  type        = string
  default     = "*"
}

variable "enable_https_access" {
  description = "Enable HTTPS access (port 443)"
  type        = bool
  default     = false
}

variable "https_source_address_prefix" {
  description = "Source address prefix for HTTPS access"
  type        = string
  default     = "*"
}

variable "custom_security_rules" {
  description = "Custom security rules"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
    description                = string
  }))
  default = []
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
