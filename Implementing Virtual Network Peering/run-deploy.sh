#!/bin/bash

# 1. Log in to the current Azure sandbox session
echo "🔐 Logging into Azure..."
az login -u "$WhizlabsLabStudentRole-lab-398-2294902-c2bb6559@instructorwhizlabs.onmicrosoft.com" -p "L*qB%2dZ"

# 2. Run the deployment
echo "🚀 Deploying VNet to $WHIZ_RG..."
az deployment group create \
  --resource-group "$WHIZ_RG" \
  --template-file ./vnet.bicep \
  --parameters @./vnet.parameters.yaml