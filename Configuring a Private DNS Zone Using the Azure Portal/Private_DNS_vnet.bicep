 param location string = 'eastus'
 resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
   name: 'whizVnet'
   location: location
   properties: {
     addressSpace: {
       addressPrefixes: [
         '10.2.0.0/16'
       ]
     }
     subnets: [
       {
         name: 'whizSubnet'
         properties: {
           addressPrefix: '10.2.0.0/24'
         }
       }
       
     ]
   }
 }
