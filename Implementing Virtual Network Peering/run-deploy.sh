#!/bin/bash
set -e

# 1. Fallback: If no parameter file is provided as an argument, default to your first file
PARAM_FILE=${1:-"./vnet.bicepparam"}

# 2. Check if you are already authenticated to skip the web login lag
if ! az account show &> /dev/null; then
    echo "🔐 Opening Azure login portal..."
    az login --use-device-code
fi

# 3. Automatically find the active sandbox resource group name
echo "🔍 Fetching sandbox resource group name..."
WHIZ_RG=$(az group list --query "[0].name" -o tsv)

# 4. Deploy using whatever parameter file you passed into the script
echo "🚀 Deploying network configuration using $PARAM_FILE to $WHIZ_RG..."
az deployment group create \
  --resource-group "$WHIZ_RG" \
  --template-file ./vnet_template.bicep \
  --parameters "$PARAM_FILE"
