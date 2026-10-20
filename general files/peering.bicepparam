using './vnet_peering_template.bicep'

// Define the two VNets that should be peered together
param localVnetName = 'whizNet1'
param remoteVnetName = 'whizNet2'
