#!/bin/bash
az deployment group create \
  --resource-group $WHIZ_RG \
  --template-file ./vnet.bicep \
  --parameters @./vnet.parameters.yaml