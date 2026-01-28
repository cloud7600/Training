// Virtual Network Module
@description('The name of the virtual network')
param vnetName string

@description('The location for the virtual network')
param location string = resourceGroup().location

@description('The address prefix for the virtual network')
param addressPrefix string = '10.0.0.0/16'

@description('Array of subnet configurations')
param subnets array = [
  {
    name: 'default'
    addressPrefix: '10.0.0.0/24'
  }
]

@description('Tags to apply to the virtual network')
param tags object = {}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [for subnet in subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.addressPrefix
      }
    }]
  }
}

@description('The resource ID of the virtual network')
output vnetId string = virtualNetwork.id

@description('The name of the virtual network')
output vnetName string = virtualNetwork.name

@description('Array of subnet resource IDs')
output subnetIds array = [for (subnet, i) in subnets: virtualNetwork.properties.subnets[i].id]
