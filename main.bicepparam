# This tells Azure which Bicep blueprint file to populate
using './main.bicep'

param virtualNetworks_myPIPVnet_name = 'myPIPVnet'
param virtualMachines_myWhizlabsVM1_name = 'myWhizlabsVM1'
param networkInterfaces_mywhizlabsvm1326_name = 'mywhizlabsvm1326'
param publicIPAddresses_myWhizlabsVM1_ip_name = 'myWhizlabsVM1-ip'
param networkSecurityGroups_myWhizlabsVM1_nsg_name = 'myWhizlabsVM1-nsg'
