// Main deployment template
targetScope = 'resourceGroup'

@description('The location for all resources')
param location string = resourceGroup().location

@description('The environment name (dev, test, prod)')
@allowed([
  'dev'
  'test'
  'prod'
])
param environment string

@description('The project name to use for resource naming')
param projectName string

@description('Tags to apply to all resources')
param tags object = {
  Environment: environment
  Project: projectName
  ManagedBy: 'Bicep'
}

// Variables
var storageAccountName = '${projectName}${environment}sa'
var vnetName = '${projectName}-${environment}-vnet'

// Deploy Storage Account
module storageAccount '../modules/storage/storageAccount.bicep' = {
  name: 'storageAccountDeployment'
  params: {
    storageAccountName: storageAccountName
    location: location
    skuName: environment == 'prod' ? 'Standard_GRS' : 'Standard_LRS'
    tags: tags
  }
}

// Deploy Virtual Network
module virtualNetwork '../modules/networking/virtualNetwork.bicep' = {
  name: 'virtualNetworkDeployment'
  params: {
    vnetName: vnetName
    location: location
    addressPrefix: '10.0.0.0/16'
    subnets: [
      {
        name: 'default'
        addressPrefix: '10.0.0.0/24'
      }
      {
        name: 'webapp'
        addressPrefix: '10.0.1.0/24'
      }
      {
        name: 'database'
        addressPrefix: '10.0.2.0/24'
      }
    ]
    tags: tags
  }
}

// Outputs
@description('The resource ID of the storage account')
output storageAccountId string = storageAccount.outputs.storageAccountId

@description('The resource ID of the virtual network')
output vnetId string = virtualNetwork.outputs.vnetId

@description('Array of subnet IDs')
output subnetIds array = virtualNetwork.outputs.subnetIds
