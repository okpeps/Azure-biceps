#!/bin/bash
set -e

# 1. Trigger an interactive web-based login instead of hardcoding text
echo "🔐 Opening Azure login portal..."
az login --use-device-code

# 2. Automatically discover the active sandbox resource group name
echo "🔍 Fetching sandbox resource group name..."
WHIZ_RG=$(az group list --query "[0].name" -o tsv)

# 3. Deploy using your valid Bicep configuration paths
echo "🚀 Deploying VNet to $WHIZ_RG..."
az deployment group create \
  --resource-group "$WHIZ_RG" \
  --template-file ./vnet_template.bicep \
  --parameters ./vnet.bicepparam
