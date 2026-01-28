# Azure Bicep Infrastructure as Code (IaC) Training

This repository contains Azure Bicep templates for deploying infrastructure to Azure. It demonstrates best practices for Infrastructure as Code using Azure Bicep.

## 📁 Repository Structure

```
.
├── deployments/           # Main deployment templates
│   └── main.bicep        # Main deployment orchestrator
├── modules/              # Reusable Bicep modules
│   ├── storage/         # Storage account modules
│   │   └── storageAccount.bicep
│   ├── networking/      # Networking modules
│   │   └── virtualNetwork.bicep
│   └── security/        # Security modules
│       └── keyVault.bicep
├── parameters/          # Parameter files per environment
│   ├── dev/            # Development environment parameters
│   ├── test/           # Test environment parameters
│   └── prod/           # Production environment parameters
├── scripts/            # Deployment scripts
│   ├── deploy.sh       # Bash deployment script
│   └── deploy.ps1      # PowerShell deployment script
└── bicepconfig.json    # Bicep linting configuration
```

## 🚀 Getting Started

### Prerequisites

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed
- [Bicep CLI](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install) installed
- An active Azure subscription
- Appropriate permissions to create resources in Azure

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/cloud7600/Training.git
   cd Training
   ```

2. Login to Azure:
   ```bash
   az login
   ```

3. Set your subscription (if you have multiple):
   ```bash
   az account set --subscription "YOUR_SUBSCRIPTION_ID"
   ```

## 📝 Usage

### Deploying with Bash Script

```bash
cd scripts
./deploy.sh \
  --environment dev \
  --resource-group myResourceGroup \
  --location eastus
```

### Deploying with PowerShell Script

```powershell
cd scripts
.\deploy.ps1 `
  -Environment dev `
  -ResourceGroupName myResourceGroup `
  -Location eastus
```

### Deploying Directly with Azure CLI

```bash
az deployment group create \
  --resource-group myResourceGroup \
  --template-file deployments/main.bicep \
  --parameters parameters/dev/main.parameters.json
```

## 🔧 Configuration

### Parameter Files

Each environment (dev, test, prod) has its own parameter file in the `parameters/` directory. Update these files with your specific values:

- **projectName**: Name of your project (used for resource naming)
- **environment**: Environment name (dev, test, prod)
- **location**: Azure region for deployment

### Bicep Configuration

The `bicepconfig.json` file contains linting rules and analyzer settings. Customize these based on your organization's standards.

## 🧩 Available Modules

### Storage Account Module
- Located in `modules/storage/storageAccount.bicep`
- Creates a secure storage account with:
  - TLS 1.2 minimum
  - HTTPS-only traffic
  - Disabled public blob access
  - Encryption enabled

### Virtual Network Module
- Located in `modules/networking/virtualNetwork.bicep`
- Creates a virtual network with customizable subnets
- Supports multiple subnet configurations

### Key Vault Module
- Located in `modules/security/keyVault.bicep`
- Creates a secure Key Vault with:
  - RBAC authorization
  - Soft delete and purge protection
  - Private network access (requires private endpoints)
  - Network ACLs configured

## 🔍 Validating Templates

Before deploying, you can validate your Bicep templates:

```bash
# Validate a specific template
az deployment group validate \
  --resource-group myResourceGroup \
  --template-file deployments/main.bicep \
  --parameters parameters/dev/main.parameters.json

# Build Bicep to ARM JSON (for review)
az bicep build --file deployments/main.bicep
```

## 🧪 Testing

To test your changes without deploying, use the What-If operation:

```bash
az deployment group what-if \
  --resource-group myResourceGroup \
  --template-file deployments/main.bicep \
  --parameters parameters/dev/main.parameters.json
```

## 📚 Best Practices

1. **Modularity**: Keep modules focused and reusable
2. **Parameters**: Use parameter files for environment-specific values
3. **Naming**: Follow consistent naming conventions
4. **Security**: Never hardcode secrets; use Azure Key Vault
5. **Validation**: Always validate templates before deployment
6. **Version Control**: Track all changes in Git
7. **Documentation**: Keep README and inline comments up to date

## 🛠️ Development

### Adding New Modules

1. Create a new `.bicep` file in the appropriate `modules/` subdirectory
2. Define clear parameters with descriptions and validation
3. Include outputs for resources that will be referenced
4. Update the main deployment template to use the new module

### Linting

Bicep has built-in linting. Run it with:

```bash
az bicep lint --file deployments/main.bicep
```

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Test thoroughly
4. Submit a pull request

## 📖 Resources

- [Azure Bicep Documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- [Bicep Best Practices](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/best-practices)
- [Azure Architecture Center](https://docs.microsoft.com/en-us/azure/architecture/)
- [Bicep GitHub Repository](https://github.com/Azure/bicep)

## 📄 License

This project is licensed under the MIT License.

## ✨ Authors

- Cloud7600

---

**Note**: Remember to update parameter files with your specific values before deploying to Azure.