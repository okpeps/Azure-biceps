metadata description = 'A generic, reusable Bicep template that dynamically supports both Windows and Linux deployments with custom NSGs.'

@description('The Azure region where the resources will be deployed.')
param location string

@description('The naming prefix used for the VM and its network interfaces.')
param vmName string

@description('The size specification for the Virtual Machine SKU.')
param vmSize string

@description('The operating system category (Windows or Linux).')
@allowed([
  'Windows'
  'Linux'
])
param osType string

@description('The name of the resource group where the target VNet is hosted.')
param vnetResourceGroup string

@description('The name of the target Virtual Network.')
param vnetName string

@description('The name of the specific Subnet within the VNet.')
param subnetName string

@description('The sizing configuration for the OS storage disk.')
param osDiskSizeGB int
param osDiskStorageType string = 'StandardSSD_LRS'

@description('The Image Publisher (e.g., MicrosoftWindowsServer, Canonical).')
param imagePublisher string
@description('The OS Offer SKU profile (e.g., WindowsServer, 0001-com-ubuntu-server-jammy).')
param imageOffer string
@description('The exact OS version distribution reference tag.')
param imageSku string

@description('Administrative system account login ID.')
param adminUsername string

@description('Secret authorization key token or account password.')
@secure()
param adminPasswordOrKey string

// 1. Reference your existing Virtual Network
resource targetVnet 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  scope: resourceGroup(vnetResourceGroup) // 👈 This correctly calls the resourceGroup function scope
  name: vnetName
}


// 2. Provision a dynamic Network Security Group with your rules
resource nsg 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: '${vmName}-nsg'
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
    ]
  }
}

// 3. Generate the Network Interface Card (NIC) and attach the NSG
resource nic 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: '${vmName}-nic'
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
          subnet: {
            id: '${targetVnet.id}/subnets/${subnetName}'
          }
        }
      }
    ]
  }
}

// 4. Provision the baseline compute engine with dynamic OS parameters
resource vm 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPasswordOrKey
      // Uses a conditional check: configuration is ONLY attached if deploying a Linux image
      linuxConfiguration: (osType == 'Linux') ? {
        disablePasswordAuthentication: false
      } : null
    }
    storageProfile: {
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: imageSku
        version: 'latest'
      }
      osDisk: {
        name: '${vmName}-osdisk'
        createOption: 'FromImage'
        osType: osType
        diskSizeGB: osDiskSizeGB
        managedDisk: {
          storageAccountType: osDiskStorageType
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
          id: nic.id
        }
      ]
    }
  }
}

output vmId string = vm.id
