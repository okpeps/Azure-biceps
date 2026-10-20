using './vnet_template.bicep'

param location = 'eastus'
param vnetName = 'whizNet1'
param vnetAddressPrefix = '10.1.0.0/16'
param subnetName = 'SubnetA'
param subnetAddressPrefix = '10.1.0.0/24'
