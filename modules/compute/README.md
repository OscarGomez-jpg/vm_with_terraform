# Compute Module

This module creates Azure virtual machines with optimized configurations for cost-effectiveness and security, including network interfaces, storage, and optional auto-shutdown schedules.

## Features

- **Linux Virtual Machine**: Configurable VM with Ubuntu 18.04 LTS (cost-optimized)
- **Network Interface**: Automatic NIC creation with subnet and public IP association
- **Security Integration**: Automatic NSG association for network security
- **Flexible Authentication**: Support for both password and SSH key authentication
- **Auto-shutdown**: Optional cost-saving auto-shutdown schedule
- **Storage Optimization**: Configurable disk types and sizes for cost optimization

## Usage

```hcl
module "compute" {
  source = "./modules/compute"

  name_prefix         = "my-vm"
  location           = "eastus"
  resource_group_name = "my-vm-rg"
  subnet_id          = module.networking.subnet_id
  public_ip_id       = module.networking.public_ip_id
  network_security_group_id = module.security.network_security_group_id
  
  # VM Configuration
  vm_name     = "my-vm"
  vm_size     = "Standard_B1ls"  # Cost-optimized size
  admin_username = "adminuser"
  admin_password = var.vm_password
  
  # Cost Optimization
  enable_auto_shutdown = true
  auto_shutdown_time  = "18:00"
  
  # Storage Optimization
  os_disk_storage_account_type = "Standard_LRS"  # Cheapest option
  os_disk_size_gb             = 30              # Minimum size
  
  tags = {
    Environment = "Development"
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
| subnet_id | ID of the subnet | `string` | n/a | yes |
| public_ip_id | ID of the public IP | `string` | n/a | yes |
| network_security_group_id | ID of the network security group | `string` | n/a | yes |
| vm_name | Name of the virtual machine | `string` | `"vm-demo"` | no |
| vm_size | Size of the virtual machine | `string` | `"Standard_B1ls"` | no |
| admin_username | Admin username for the VM | `string` | n/a | yes |
| admin_password | Admin password for the VM | `string` | n/a | yes |
| ssh_public_key | SSH public key for authentication | `string` | `null` | no |
| disable_password_authentication | Disable password authentication | `bool` | `false` | no |
| os_disk_caching | Caching type for the OS disk | `string` | `"ReadWrite"` | no |
| os_disk_storage_account_type | Storage account type for the OS disk | `string` | `"Standard_LRS"` | no |
| os_disk_size_gb | Size of the OS disk in GB | `number` | `30` | no |
| image_publisher | Publisher of the VM image | `string` | `"Canonical"` | no |
| image_offer | Offer of the VM image | `string` | `"UbuntuServer"` | no |
| image_sku | SKU of the VM image | `string` | `"18.04-LTS"` | no |
| image_version | Version of the VM image | `string` | `"latest"` | no |
| enable_auto_shutdown | Enable auto-shutdown schedule | `bool` | `true` | no |
| auto_shutdown_time | Time for auto-shutdown (HH:MM) | `string` | `"18:00"` | no |
| auto_shutdown_timezone | Timezone for auto-shutdown | `string` | `"UTC"` | no |
| tags | Tags to apply to resources | `map(string)` | See variables.tf | no |

## Outputs

| Name | Description |
|------|-------------|
| virtual_machine_id | ID of the virtual machine |
| virtual_machine_name | Name of the virtual machine |
| virtual_machine_public_ip | Public IP address of the virtual machine |
| virtual_machine_private_ip | Private IP address of the virtual machine |
| network_interface_id | ID of the network interface |
| network_interface_name | Name of the network interface |
| auto_shutdown_schedule_id | ID of the auto-shutdown schedule |

## Cost Optimization Features

### VM Size Selection
- **Standard_B1ls**: Burstable performance, 1 vCPU, 0.5 GB RAM - Most cost-effective for light workloads
- **Alternative Options**: Standard_B1s (1 vCPU, 1 GB RAM) for slightly more demanding workloads

### Storage Optimization
- **Standard_LRS**: Lowest cost storage option
- **30 GB Disk**: Minimum size for Ubuntu 18.04 LTS
- **ReadWrite Caching**: Optimal for general workloads

### Auto-shutdown
- **Automatic Shutdown**: Prevents unnecessary costs during non-business hours
- **Configurable Time**: Set shutdown time based on usage patterns
- **Timezone Support**: Proper timezone configuration for global deployments

## Security Features

### Authentication Options
- **Password Authentication**: Simple setup for development environments
- **SSH Key Authentication**: More secure option for production environments
- **Mixed Authentication**: Support for both methods simultaneously

### Network Security
- **NSG Integration**: Automatic association with network security groups
- **Private IP**: Internal network communication
- **Public IP**: External access when needed

## Performance Considerations

### Burstable Performance
- **B1ls Series**: Ideal for development, testing, and light workloads
- **CPU Credits**: Accumulates credits during low usage, uses them during high usage
- **Cost-Effective**: Pay only for what you use

### Storage Performance
- **Standard_LRS**: Sufficient for most development workloads
- **Upgrade Path**: Easy to upgrade to Premium storage if needed

## Best Practices

1. **Use Auto-shutdown**: Always enable for development environments
2. **Monitor Usage**: Track CPU credits and performance metrics
3. **Regular Updates**: Keep the OS and applications updated
4. **Backup Strategy**: Implement regular backups for important data
5. **Resource Tagging**: Use consistent tagging for cost tracking
