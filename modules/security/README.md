# Security Module

This module creates network security groups and configurable security rules for Azure virtual machines, providing network-level security controls.

## Features

- **Network Security Group**: Creates NSG with configurable security rules
- **SSH Access**: Configurable SSH access with customizable source address prefixes
- **HTTP/HTTPS Access**: Optional HTTP and HTTPS access rules
- **Custom Rules**: Support for additional custom security rules
- **Flexible Configuration**: Enable/disable specific access rules as needed

## Usage

```hcl
module "security" {
  source = "./modules/security"

  name_prefix         = "my-vm"
  location           = "eastus"
  resource_group_name = "my-vm-rg"
  
  # SSH access configuration
  ssh_source_address_prefix = "203.0.113.0/24"  # Restrict to specific IP range
  
  # Optional web access
  enable_http_access  = true
  enable_https_access = true
  
  # Custom security rules
  custom_security_rules = [
    {
      name                       = "CustomPort"
      priority                   = 2000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "8080"
      source_address_prefix      = "10.0.0.0/8"
      destination_address_prefix = "*"
      description                = "Allow custom port 8080 from internal networks"
    }
  ]
  
  tags = {
    Environment = "Production"
    Project     = "MyProject"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name_prefix | Prefix for naming resources | `string` | `"vm-demo"` | no |
| location | Azure region for resources | `string` | n/a | yes |
| resource_group_name | Name of the resource group | `string` | n/a | yes |
| ssh_source_address_prefix | Source address prefix for SSH access | `string` | `"*"` | no |
| enable_http_access | Enable HTTP access (port 80) | `bool` | `false` | no |
| http_source_address_prefix | Source address prefix for HTTP access | `string` | `"*"` | no |
| enable_https_access | Enable HTTPS access (port 443) | `bool` | `false` | no |
| https_source_address_prefix | Source address prefix for HTTPS access | `string` | `"*"` | no |
| custom_security_rules | Custom security rules | `list(object)` | `[]` | no |
| tags | Tags to apply to resources | `map(string)` | See variables.tf | no |

## Outputs

| Name | Description |
|------|-------------|
| network_security_group_id | ID of the network security group |
| network_security_group_name | Name of the network security group |

## Security Best Practices

- **Restrict SSH Access**: Use specific IP ranges instead of `*` for production environments
- **Principle of Least Privilege**: Only enable necessary ports and protocols
- **Regular Review**: Periodically review and update security rules
- **Logging**: Consider enabling NSG flow logs for security monitoring

## Cost Optimization

- **No Additional Cost**: NSGs are free resources in Azure
- **Efficient Rules**: Use specific port ranges and protocols to minimize rule complexity
- **Regional Placement**: Place NSGs in the same region as resources to minimize latency

## Security Considerations

- **Default Deny**: All traffic is denied by default unless explicitly allowed
- **Rule Priority**: Lower numbers have higher priority (1001, 1002, etc.)
- **Source Restrictions**: Consider restricting source addresses for better security
- **Protocol Specificity**: Use specific protocols (TCP, UDP) instead of "Any" when possible
