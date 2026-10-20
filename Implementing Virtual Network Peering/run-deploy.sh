#!/bin/bash
set -e

# 1. Log in to the current Azure sandbox session FIRST
echo "🔐 Logging into Azure..."
# NOTE: Single quotes around the password prevent Bash from misinterpreting the '$' character!
az login -u "WhizlabsLabStudentRole-lab-398-2294902-c2bb6559@instructorwhizlabs.onmicrosoft.com" -p 'L*qB%2dZ'

# 2. NOW query the active resource group name (after login is complete)
echo "🔍 Fetching sandbox resource group name..."
WHIZ_RG=$(az group list --query "[0].name" -o tsv)

# 3. Run the deployment pointing directly to your valid Bicep configuration paths
echo "🚀 Deploying VNet to $WHIZ_RG..."
az deployment group create \
  --resource-group "$WHIZ_RG" \
  --template-file ./vnet_template.bicep \
  --parameters ./vnet.bicepparam
