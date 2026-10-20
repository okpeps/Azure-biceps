// 1. Declare incoming parameters for the two VNets you want to connect
param localVnetName string
param remoteVnetName string

// 2. Reference the existing Local VNet (so Bicep knows where to attach the first peering)
resource localVnet 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  name: localVnetName
}

// 3. Reference the existing Remote VNet (so Bicep can find its target ID)
resource remoteVnet 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  name: remoteVnetName
}

// 4. Create Peering Side A: From Local VNet pointing to Remote VNet
resource peeringLocalToRemote 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = {
  name: '${localVnetName}-to-${remoteVnetName}'
  parent: localVnet
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: remoteVnet.id
    }
  }
}

// 5. Create Peering Side B: From Remote VNet pointing back to Local VNet
resource peeringRemoteToLocal 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = {
  name: '${remoteVnetName}-to-${localVnetName}'
  parent: remoteVnet
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: localVnet.id
    }
  }
}
