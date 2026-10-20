using 'vm_template.bicep'

// Region & Basic Naming Configs
param location = 'eastus'
param vmName = 'vm1'
param vmSize = 'Standard_B2s'
param osType = 'Windows' // 👈 Added: Can be 'Windows' or 'Linux'

// Network Targeting Configuration 
param vnetName = 'whizNet1'
param subnetName = 'SubnetA'

// Storage Configuration
param osDiskSizeGB = 127
param osDiskStorageType = 'StandardSSD_LRS'

// OS Image Profile (Windows Server 2025 Azure Edition)
param imagePublisher = 'MicrosoftWindowsServer'
param imageOffer = 'WindowsServer'
param imageSku = '2025-datacenter-azure-edition'

// Security Credentials Configs
param adminUsername = 'okpeps'
param adminPasswordOrKey = 'okpeps1!'
