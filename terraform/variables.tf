variable "resource_group_location" {
  default     = "East US"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}


variable "vm_name" {
  default     = "ubuntu-vm-mssql"
  description = "ubuntu-machine"
}

variable "vm_size" {
  default     = "Standard_B2s"
  description = "Size of the Azure VM."
}



# variable "agent_count" {
#   default = 3
# }

# # The following two variable declarations are placeholder references.
# # Set the values for these variable in terraform.tfvars
# variable "aks_service_principal_app_id" {
#   type = string
#   default = "5f7aa260-ae5c-4a7b-825a-887728c493d9"
# }

# variable "aks_service_principal_client_secret" {
#   type = string
#   default = "-5F8Q~AJgwnIS6xwW6JTttDVmj-3j74dil_riax1"
# }

# variable "cluster_name" {
#   default = "k8stest"
# }

# variable "acr_name" {
#   default = "acrappfaluz"
# }

# variable "dns_prefix" {
#   default = "k8stest"
# }

# # Refer to https://azure.microsoft.com/global-infrastructure/services/?products=monitor for available Log Analytics regions.
# variable "log_analytics_workspace_location" {
#   default = "East US"
# }

# variable "log_analytics_workspace_name" {
#   default = "testLogAnalyticsWorkspaceName"
# }

# # Refer to https://azure.microsoft.com/pricing/details/monitor/ for Log Analytics pricing
# variable "log_analytics_workspace_sku" {
#   default = "PerGB2018"
# }

# variable "resource_group_location" {
#   default     = "East US"
#   description = "Location of the resource group."
# }

# variable "resource_group_name_prefix" {
#   default     = "rg"
#   description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
# }

# variable "ssh_public_key" {
#   default = "~/.ssh/id_rsa.pub"
# }

