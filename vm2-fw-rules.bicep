param location string = resourceGroup().location
param vmName string = 'vm2' 
resource existingVM 'Microsoft.Compute/virtualMachines@2024-03-01' existing = {
  name: vmName
}

// Deploy the extension to execute the PowerShell command inside the guest OS
resource configFirewall 'Microsoft.Compute/virtualMachines/extensions@2024-03-01' = {
  name: 'EnableICMP'
  parent: existingVM
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      commandToExecute: 'powershell -ExecutionPolicy Bypass -Command "Enable-NetFirewallRule -DisplayName \'File and Printer Sharing (Echo Request - ICMPv4-In)\'"'
    }
  }
}