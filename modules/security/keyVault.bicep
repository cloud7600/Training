// Azure Key Vault Module
@description('The name of the key vault')
param keyVaultName string

@description('The location for the key vault')
param location string = resourceGroup().location

@description('The SKU of the key vault')
@allowed([
  'standard'
  'premium'
])
param skuName string = 'standard'

@description('The tenant ID for the key vault')
param tenantId string = subscription().tenantId

@description('Enable soft delete for the key vault')
param enableSoftDelete bool = true

@description('Number of days to retain deleted items')
param softDeleteRetentionInDays int = 90

@description('Enable purge protection')
param enablePurgeProtection bool = true

@description('Enable RBAC authorization')
param enableRbacAuthorization bool = true

@description('Enable public network access')
param enablePublicAccess bool = false

@description('Tags to apply to the key vault')
param tags object = {}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  tags: tags
  properties: {
    sku: {
      family: 'A'
      name: skuName
    }
    tenantId: tenantId
    enableSoftDelete: enableSoftDelete
    softDeleteRetentionInDays: softDeleteRetentionInDays
    enablePurgeProtection: enablePurgeProtection
    enableRbacAuthorization: enableRbacAuthorization
    publicNetworkAccess: enablePublicAccess ? 'Enabled' : 'Disabled'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
  }
}

@description('The resource ID of the key vault')
output keyVaultId string = keyVault.id

@description('The name of the key vault')
output keyVaultName string = keyVault.name

@description('The URI of the key vault')
output keyVaultUri string = keyVault.properties.vaultUri
