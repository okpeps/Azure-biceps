 param location string = 'eastus'
 resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
   name: 'myPIPVnet'
   location: location
   properties: {
     addressSpace: {
       addressPrefixes: [
         '10.10.0.0/16'
       ]
     }
     subnets: [
       {
         name: 'WebSubnet'
         properties: {
           addressPrefix: '10.10.0.0/24'
         }
       }
       
     ]
   }
 }
