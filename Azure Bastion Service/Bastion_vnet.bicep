 param location string = 'eastus'
 resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
   name: 'mywhiznet'
   location: location
   properties: {
     addressSpace: {
       addressPrefixes: [
         '10.1.0.0/16'
       ]
     }
     subnets: [
       {
         name: 'Subnet1'
         properties: {
           addressPrefix: '10.1.0.0/24'
         }
       }
       
     ]
   }
 }