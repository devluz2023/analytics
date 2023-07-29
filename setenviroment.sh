# Save the script as set_env_variables.sh
#!/bin/bash

# Your service_principal data
service_principal_data='{
  "appId": "e4019664-9f1c-411b-8996-df0997b3544d",
  "displayName": "azure-cli-2023-07-29-17-02-48",
  "password": "pJd8Q~3A8P_fpwB_o2q3sKybOyPFw04ARXQZaavA",
  "tenant": "e3bec813-1df7-418a-9c23-b6ed3ba33e33"
}'

# Parse service_principal and set environment variables
export APP_ID=$(echo "$service_principal_data" | jq -r '.appId')
export DISPLAY_NAME=$(echo "$service_principal_data" | jq -r '.displayName')
export PASSWORD=$(echo "$service_principal_data" | jq -r '.password')
export TENANT=$(echo "$service_principal_data" | jq -r '.tenant')

# Display the set environment variables (optional)
echo "APP_ID: $APP_ID"
echo "DISPLAY_NAME: $DISPLAY_NAME"
echo "PASSWORD: $PASSWORD"
echo "TENANT: $TENANT"
