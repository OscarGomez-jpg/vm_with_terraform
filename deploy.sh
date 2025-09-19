#!/bin/bash

# Azure VM Deployment Script
# This script provides a convenient way to deploy the infrastructure

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check if terraform is installed
    if ! command -v terraform &> /dev/null; then
        print_error "Terraform is not installed. Please install Terraform first."
        exit 1
    fi
    
    # Check if azure cli is installed
    if ! command -v az &> /dev/null; then
        print_error "Azure CLI is not installed. Please install Azure CLI first."
        exit 1
    fi
    
    # Check if user is logged in to Azure
    if ! az account show &> /dev/null; then
        print_error "Not logged in to Azure. Please run 'az login' first."
        exit 1
    fi
    
    print_success "Prerequisites check passed"
}

# Function to validate terraform configuration
validate_terraform() {
    print_status "Validating Terraform configuration..."
    
    # Format terraform files
    terraform fmt -recursive
    
    # Validate configuration
    if terraform validate; then
        print_success "Terraform configuration is valid"
    else
        print_error "Terraform configuration validation failed"
        exit 1
    fi
}

# Function to deploy infrastructure
deploy_infrastructure() {
    local environment=$1
    local subscription_id=$2
    local admin_password=$3
    
    print_status "Deploying infrastructure for environment: $environment"
    
    # Initialize terraform
    print_status "Initializing Terraform..."
    terraform init
    
    # Plan deployment
    print_status "Planning deployment..."
    if [ "$environment" = "default" ]; then
        terraform plan \
            -var="subscription_id=$subscription_id" \
            -var="admin_password=$admin_password"
    else
        terraform plan \
            -var-file="environments/$environment/terraform.tfvars" \
            -var="subscription_id=$subscription_id" \
            -var="admin_password=$admin_password"
    fi
    
    # Ask for confirmation
    echo
    print_warning "This will create Azure resources that may incur costs."
    read -p "Do you want to proceed? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Deployment cancelled"
        exit 0
    fi
    
    # Apply configuration
    print_status "Applying configuration..."
    if [ "$environment" = "default" ]; then
        terraform apply \
            -var="subscription_id=$subscription_id" \
            -var="admin_password=$admin_password" \
            -auto-approve
    else
        terraform apply \
            -var-file="environments/$environment/terraform.tfvars" \
            -var="subscription_id=$subscription_id" \
            -var="admin_password=$admin_password" \
            -auto-approve
    fi
    
    print_success "Infrastructure deployed successfully!"
    
    # Show outputs
    print_status "Infrastructure outputs:"
    terraform output
}

# Function to destroy infrastructure
destroy_infrastructure() {
    local environment=$1
    local subscription_id=$2
    
    print_status "Destroying infrastructure for environment: $environment"
    
    # Ask for confirmation
    echo
    print_warning "This will DESTROY all Azure resources created by this configuration."
    read -p "Are you sure you want to proceed? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Destruction cancelled"
        exit 0
    fi
    
    # Destroy infrastructure
    if [ "$environment" = "default" ]; then
        terraform destroy \
            -var="subscription_id=$subscription_id" \
            -var="admin_password=dummy" \
            -auto-approve
    else
        terraform destroy \
            -var-file="environments/$environment/terraform.tfvars" \
            -var="subscription_id=$subscription_id" \
            -var="admin_password=dummy" \
            -auto-approve
    fi
    
    print_success "Infrastructure destroyed successfully!"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [COMMAND] [ENVIRONMENT] [OPTIONS]"
    echo
    echo "Commands:"
    echo "  deploy    Deploy infrastructure"
    echo "  destroy   Destroy infrastructure"
    echo "  validate  Validate Terraform configuration"
    echo "  plan      Plan infrastructure changes"
    echo
    echo "Environments:"
    echo "  dev       Development environment"
    echo "  staging   Staging environment"
    echo "  prod      Production environment"
    echo "  default   Default configuration (no environment file)"
    echo
    echo "Options:"
    echo "  --subscription-id    Azure subscription ID"
    echo "  --admin-password     VM admin password"
    echo
    echo "Examples:"
    echo "  $0 deploy dev --subscription-id 12345678-1234-1234-1234-123456789012 --admin-password MyPassword123!"
    echo "  $0 destroy dev --subscription-id 12345678-1234-1234-1234-123456789012"
    echo "  $0 validate"
}

# Main script logic
main() {
    local command=$1
    local environment=$2
    local subscription_id=""
    local admin_password=""
    
    # Parse arguments
    shift 2
    while [[ $# -gt 0 ]]; do
        case $1 in
            --subscription-id)
                subscription_id="$2"
                shift 2
                ;;
            --admin-password)
                admin_password="$2"
                shift 2
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Check prerequisites
    check_prerequisites
    
    case $command in
        deploy)
            if [ -z "$subscription_id" ] || [ -z "$admin_password" ]; then
                print_error "Subscription ID and admin password are required for deployment"
                show_usage
                exit 1
            fi
            validate_terraform
            deploy_infrastructure "$environment" "$subscription_id" "$admin_password"
            ;;
        destroy)
            if [ -z "$subscription_id" ]; then
                print_error "Subscription ID is required for destruction"
                show_usage
                exit 1
            fi
            destroy_infrastructure "$environment" "$subscription_id"
            ;;
        validate)
            validate_terraform
            ;;
        plan)
            if [ -z "$subscription_id" ] || [ -z "$admin_password" ]; then
                print_error "Subscription ID and admin password are required for planning"
                show_usage
                exit 1
            fi
            validate_terraform
            terraform init
            if [ "$environment" = "default" ]; then
                terraform plan \
                    -var="subscription_id=$subscription_id" \
                    -var="admin_password=$admin_password"
            else
                terraform plan \
                    -var-file="environments/$environment/terraform.tfvars" \
                    -var="subscription_id=$subscription_id" \
                    -var="admin_password=$admin_password"
            fi
            ;;
        *)
            print_error "Unknown command: $command"
            show_usage
            exit 1
            ;;
    esac
}

# Check if script is being sourced or executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [ $# -lt 2 ]; then
        show_usage
        exit 1
    fi
    main "$@"
fi
