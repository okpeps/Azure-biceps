param location string = 'eastus'

// 1. Create the NSG FIRST so it exists in the context for resources below it
resource nsg 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: 'nsg1'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-HTTP'
        properties: {
          priority: 1000
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '80'
        }
      }
      {
        name: 'Allow-SSH'
        properties: {
          priority: 1010
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
      {
          name: 'Allow-RDP'
          properties: {
          priority: 1020
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
        }
      }
            {
          name: 'Allow-HTTPS'
          properties: {
          priority: 1030
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
        }
      }
    ]
  }
}

// 1.1 ADD A PUBLIC IP RESOURCE
resource publicIp 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
  name: 'myWhizlabsVM1-ip'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

// 2. Every VM needs a Network Interface (NIC)
resource networkInterface 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: 'nic1'
  location: location
  properties: {
    networkSecurityGroup: {
      id: nsg.id 
    }
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          // LINK THE PUBLIC IP HERE
          publicIPAddress: {
            id: publicIp.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'myPIPVnet', 'WebSubnet')
          }
        }
      }
    ]
  }
}

// 3. The Virtual Machine
resource virtualMachine 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: 'myWhizlabsVM1'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    osProfile: {
      computerName: 'myWhizlabsVM1'
      adminUsername: 'okpeps'
      adminPassword: 'Chewallera29!' 
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        osType: 'Windows'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
        deleteOption: 'Delete' 
      }
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: false 
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
  }
}
