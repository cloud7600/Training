#!/bin/bash
# Deployment script for Azure Bicep templates

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Exit on error
set -e

# Default values
ENVIRONMENT="dev"
RESOURCE_GROUP=""
LOCATION="eastus"
SUBSCRIPTION_ID=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -e|--environment)
      ENVIRONMENT="$2"
      shift 2
      ;;
    -g|--resource-group)
      RESOURCE_GROUP="$2"
      shift 2
      ;;
    -l|--location)
      LOCATION="$2"
      shift 2
      ;;
    -s|--subscription)
      SUBSCRIPTION_ID="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  -e, --environment     Environment to deploy (dev, test, prod) [default: dev]"
      echo "  -g, --resource-group  Resource group name (required)"
      echo "  -l, --location        Azure region [default: eastus]"
      echo "  -s, --subscription    Azure subscription ID (optional)"
      echo "  -h, --help            Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Validate required parameters
if [ -z "$RESOURCE_GROUP" ]; then
  echo "Error: Resource group name is required (-g|--resource-group)"
  exit 1
fi

# Validate environment
if [[ ! "$ENVIRONMENT" =~ ^(dev|test|prod)$ ]]; then
  echo "Error: Environment must be dev, test, or prod"
  exit 1
fi

echo "========================================="
echo "Azure Bicep Deployment Script"
echo "========================================="
echo "Environment:     $ENVIRONMENT"
echo "Resource Group:  $RESOURCE_GROUP"
echo "Location:        $LOCATION"
echo "========================================="

# Set subscription if provided
if [ -n "$SUBSCRIPTION_ID" ]; then
  echo "Setting subscription to: $SUBSCRIPTION_ID"
  az account set --subscription "$SUBSCRIPTION_ID"
fi

# Create resource group if it doesn't exist
echo "Ensuring resource group exists..."
az group create --name "$RESOURCE_GROUP" --location "$LOCATION"

# Deploy the Bicep template
echo "Starting deployment..."
TEMPLATE_FILE="${SCRIPT_DIR}/../deployments/main.bicep"
PARAMETERS_FILE="${SCRIPT_DIR}/../parameters/${ENVIRONMENT}/main.parameters.json"

az deployment group create \
  --resource-group "$RESOURCE_GROUP" \
  --template-file "$TEMPLATE_FILE" \
  --parameters "$PARAMETERS_FILE" \
  --verbose

echo "========================================="
echo "Deployment completed successfully!"
echo "========================================="
