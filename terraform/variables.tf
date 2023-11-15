variable "resource_group_location" {
  default     = "East US"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "aks_service_principal_app_id" {
  type = string
}

variable "aks_service_principal_client_secret" {
  type = string
}


variable "dns_prefix" {
  default = "k8stest"
}

variable "cluster_name" {
  default = "k8stest3"
}
variable "ssh_public_key" {
  default = "~/.ssh/default-fabio.jdluz.pub"
}

variable "vm_name" {
  default     = "ubuntu-vm-mssql"
  description = "ubuntu-machine"
}

variable "vm_size" {
  default     = "Standard_B2s"
  description = "Size of the Azure VM."
}


variable "admin_username" {
  description = "The admin username for the virtual machine"
  type        = string
  default     = "adminuser"  # You can set a default value here if needed
}

variable "log_analytics_workspace_sku" {
  default = "PerGB2018"
}


variable "nsgRule1" {
  type        = map
  description = "network security group rule 1 - remember to modify 'source_address_prefix' with your own local Public IP address https://www.whatismyip.com/"
  default = {
    "name"                       = "SSH_allow"
    "description"                = "Allow inbound SSH from single Public IP to Ansible Host"
    "priority"                   = 100
    "direction"                  = "Inbound"
    "access"                     = "Allow"
    "protocol"                   = "Tcp"
    "source_port_range"          = "*"
    "destination_port_range"     = "22"
    "source_address_prefix"      = "0.0.0.0"
    "destination_address_prefix" = "10.0.0.5"
  }
}


variable "vmShutdownTime" {
  type        = string
  description = "virtual machine daily shutdown time"
  default     = "1900"
}

variable "vmShutdownTimeZone" {
  type        = string
  description = "virtual machine daily shutdown time zone"
  default     = "AUS Eastern Standard Time"
}

variable "acr_name" {
  default = "acrappfaluz"
}

variable "log_analytics_workspace_name" {
  default = "testLogAnalyticsWorkspaceName"
}

 variable "agent_count" {
   default = 3
 }

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

