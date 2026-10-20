using './vnet_template.bicep'

param location = 'westeurope'
param vnetName = 'whizNet2'
param vnetAddressPrefix = '10.2.0.0/16'
param subnetName = 'SubnetB'
param subnetAddressPrefix = '10.2.0.0/24'
