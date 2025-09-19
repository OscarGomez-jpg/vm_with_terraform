# Networking Module

This module creates the foundational networking infrastructure for Azure virtual machines, including resource groups, virtual networks, subnets, and public IP addresses.

## Features

- **Resource Group**: Creates a dedicated resource group for the infrastructure
- **Virtual Network**: Configurable address space for network isolation
- **Subnet**: Isolated subnet for VM placement
- **Public IP**: Static or dynamic public IP allocation with configurable SKU

## Usage

```hcl
module "networking" {
  source = "./modules/networking"

  name_prefix         = "my-vm"
  location           = "eastus"
  resource_group_name = "my-vm-rg"
  
  # Optional: Customize network configuration
  vnet_address_space      = ["10.0.0.0/16"]
  subnet_address_prefixes = ["10.0.1.0/24"]
  public_ip_sku          = "Standard"
  
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
| location | Azure region for resources | `string` | `"eastus"` | no |
| resource_group_name | Name of the resource group | `string` | `"vm-demo-rg"` | no |
| vnet_address_space | Address space for the virtual network | `list(string)` | `["10.0.0.0/16"]` | no |
| subnet_address_prefixes | Address prefixes for the subnet | `list(string)` | `["10.0.1.0/24"]` | no |
| public_ip_allocation_method | Allocation method for public IP | `string` | `"Static"` | no |
| public_ip_sku | SKU for the public IP | `string` | `"Standard"` | no |
| tags | Tags to apply to resources | `map(string)` | See variables.tf | no |

## Outputs

| Name | Description |
|------|-------------|
| resource_group_name | Name of the resource group |
| resource_group_location | Location of the resource group |
| virtual_network_id | ID of the virtual network |
| virtual_network_name | Name of the virtual network |
| subnet_id | ID of the subnet |
| subnet_name | Name of the subnet |
| public_ip_id | ID of the public IP |
| public_ip_address | Public IP address |

## Cost Optimization

- **Standard SKU Public IP**: More expensive than Basic but provides better features and is required for Standard load balancers
- **Static Allocation**: Slightly more expensive than Dynamic but provides consistent IP addresses
- **Single Subnet**: Minimizes network complexity and costs

## Security Considerations

- Network isolation through VNet and subnet configuration
- Public IP allows external access (consider using private endpoints for production)
- Consider implementing Network Security Groups for additional security layers
