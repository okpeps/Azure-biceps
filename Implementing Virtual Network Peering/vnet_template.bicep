// 1. Declare incoming parameters matching your YAML structure
param location string
param vnetName string
param vnetAddressPrefix string
param subnetName string
param subnetAddressPrefix string

// 2. Define the Virtual Network Resource using your custom inputs
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
        }
      }
    ]
  }
}
