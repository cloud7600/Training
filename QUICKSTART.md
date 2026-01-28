# Quick Start Guide

This guide will help you get started with deploying Azure infrastructure using the Bicep templates in this repository.

## Prerequisites Checklist

- [ ] Azure CLI installed ([Download](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli))
- [ ] Bicep CLI installed (comes with Azure CLI 2.20.0+)
- [ ] Azure subscription with appropriate permissions
- [ ] Git installed

## Step-by-Step Deployment

### 1. Clone the Repository

```bash
git clone https://github.com/cloud7600/Training.git
cd Training
```

### 2. Login to Azure

```bash
az login
```

If you have multiple subscriptions, set the one you want to use:

```bash
# List your subscriptions
az account list --output table

# Set the subscription
az account set --subscription "YOUR_SUBSCRIPTION_NAME_OR_ID"
```

### 3. Configure Parameters

Edit the parameter file for your environment. For example, to deploy to development:

```bash
# Open the dev parameter file
nano parameters/dev/main.parameters.json
```

Update the following values:
- `projectName`: A short name for your project (max 17 characters, lowercase letters and numbers only)
- `environment`: Keep as "dev" for development
- `location`: Azure region (e.g., "eastus", "westus2", "northeurope")

Example:
```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "environment": {
      "value": "dev"
    },
    "projectName": {
      "value": "demo"
    },
    "location": {
      "value": "eastus"
    }
  }
}
```

### 4. Create a Resource Group

```bash
az group create \
  --name myResourceGroup \
  --location eastus
```

### 5. Deploy Using Scripts

#### Option A: Using Bash Script (Linux/Mac)

```bash
cd scripts
chmod +x deploy.sh
./deploy.sh --environment dev --resource-group myResourceGroup --location eastus
```

#### Option B: Using PowerShell Script (Windows)

```powershell
cd scripts
.\deploy.ps1 -Environment dev -ResourceGroupName myResourceGroup -Location eastus
```

#### Option C: Using Azure CLI Directly

```bash
az deployment group create \
  --resource-group myResourceGroup \
  --template-file deployments/main.bicep \
  --parameters parameters/dev/main.parameters.json
```

### 6. Verify Deployment

After deployment completes, verify the resources were created:

```bash
# List all resources in the resource group
az resource list --resource-group myResourceGroup --output table

# Get the storage account details
az storage account show --name <your-storage-account-name> --resource-group myResourceGroup

# Get the virtual network details
az network vnet show --name <your-vnet-name> --resource-group myResourceGroup
```

## What Gets Deployed

By default, the main deployment template creates:

1. **Storage Account**
   - Name: `{projectName}{environment}sa` (e.g., `demodevsa`)
   - Type: StorageV2
   - SKU: Standard_LRS for dev/test, Standard_GRS for prod
   - Features: HTTPS-only, TLS 1.2, encryption enabled

2. **Virtual Network**
   - Name: `{projectName}-{environment}-vnet` (e.g., `demo-dev-vnet`)
   - Address space: 10.0.0.0/16
   - Subnets:
     - default: 10.0.0.0/24
     - webapp: 10.0.1.0/24
     - database: 10.0.2.0/24

## Testing Before Deployment

To see what changes would be made without actually deploying:

```bash
az deployment group what-if \
  --resource-group myResourceGroup \
  --template-file deployments/main.bicep \
  --parameters parameters/dev/main.parameters.json
```

## Troubleshooting

### Common Issues

**Issue**: "Storage account name must be between 3 and 24 characters"
- **Solution**: Make sure your `projectName` is 17 characters or less

**Issue**: "Storage account name is already taken"
- **Solution**: Storage account names must be globally unique. Change your `projectName` to something more unique

**Issue**: "Location not available"
- **Solution**: Use `az account list-locations -o table` to see available locations

**Issue**: "Authorization failed"
- **Solution**: Ensure you have Contributor or Owner role on the subscription or resource group

### Getting Help

1. Check the [README.md](README.md) for detailed documentation
2. Review [CONTRIBUTING.md](CONTRIBUTING.md) for best practices
3. Open an issue on GitHub if you encounter problems

## Cleaning Up

To delete all deployed resources:

```bash
az group delete --name myResourceGroup --yes --no-wait
```

**Warning**: This will delete ALL resources in the resource group. Make sure you're deleting the correct resource group!

## Next Steps

- Customize the modules to fit your needs
- Add new modules for additional Azure resources
- Set up different environments (test, prod)
- Configure CI/CD pipelines for automated deployments
- Review security best practices in [CONTRIBUTING.md](CONTRIBUTING.md)

## Additional Resources

- [Azure Bicep Documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- [Azure CLI Reference](https://docs.microsoft.com/en-us/cli/azure/)
- [Azure Resource Manager Templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/)
