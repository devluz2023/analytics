# #!/bin/bash

# # Function to log in to Azure
# function azure_login() {
#     echo "Logging in to Azure..."
#     az login
# }

# # Function to select an Azure subscription
# function select_subscription() {
#     echo "Fetching Azure subscriptions..."
#     local subscriptions=$(az account list --query "[].{name:name, id:id}" -o tsv)

#     echo "Available Azure Subscriptions:"
#     local i=1
#     local subscription_names=()
#     local subscription_ids=()

#     while IFS=$'\t' read -r name id; do
#         subscription_names+=("$name")
#         subscription_ids+=("$id")
#         echo "$i) $name"
#         ((i++))
#     done <<< "$subscriptions"

#     read -p "Select a subscription (1-${#subscription_names[@]}): " choice
#     local selected_id=${subscription_ids[$choice-1]}

#     echo "You selected: ${subscription_names[$choice-1]}"
#     az account set --subscription="$selected_id"
# }


function set_aks_sp_env_variables() {
    export TF_VAR_aks_service_principal_app_id="ef4454c5-2fa0-4f5e-a1ab-98c17dc3710e"
    export TF_VAR_aks_service_principal_client_secret="zyz8Q~FdkBoMigWYEGfWG..wgy32pS4wyrNt9bkF"
    echo "AKS Service Principal environment variables set."
}

set_aks_sp_env_variables