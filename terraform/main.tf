# Generate random resource group name
resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

resource "random_id" "log_analytics_workspace_name_suffix" {
  byte_length = 8
}


resource "azurerm_container_registry" "acr_app" {
  location            = azurerm_resource_group.rg.location
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_log_analytics_workspace" "test" {
  location            = var.log_analytics_workspace_location  
  # The WorkSpace name has to be unique across the whole of azure;
  # not just the current subscription/tenant.
  name                = "${var.log_analytics_workspace_name}-${random_id.log_analytics_workspace_name_suffix.dec}"
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = var.log_analytics_workspace_sku
}


resource "azurerm_log_analytics_solution" "test" {
  location              = azurerm_log_analytics_workspace.test.location
  resource_group_name   = azurerm_resource_group.rg.name
  solution_name         = "ContainerInsights"
  workspace_name        = azurerm_log_analytics_workspace.test.name
  workspace_resource_id = azurerm_log_analytics_workspace.test.id

  plan {
    product   = "OMSGallery/ContainerInsights"
    publisher = "Microsoft"
  }
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = azurerm_resource_group.rg.location
  name                = "${random_pet.rg_name.id}${var.cluster_name}"
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix
  tags                = {
    Environment = "Development"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2_v2"
    node_count = var.agent_count
  }
  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = file(var.ssh_public_key)
    }

  }
  # identity {
  #   type = "SystemAssigned"
  # }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  service_principal {
    client_id     = var.aks_service_principal_app_id
    client_secret = var.aks_service_principal_client_secret
  }

}



resource "azurerm_role_assignment" "example" {
  principal_id                     = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr_app.id
  skip_service_principal_aad_check = true
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name =  azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "example-ipconfig"
    subnet_id                     = azurerm_subnet.example.id
    public_ip_address_id          = azurerm_public_ip.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_network" "example" {
  name                = "my-virtual-network"
  address_space       = ["10.0.0.0/16"]
  location            =  azurerm_resource_group.rg.location
  resource_group_name =  azurerm_resource_group.rg.name

}

resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}


resource "azurerm_public_ip" "example" {
  name                = "jenkins-get-started-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "example" {
  name                = "jenkins-get-started-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Generate random text for a unique storage account name
resource "random_id" "random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "my_storage_account" {
  name                     = "diag${random_id.random_id.hex}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "allow-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.example.name
}
  
resource "azurerm_network_security_rule" "security_roles" {
  name                        = "allow-http"
  priority                    = 1010
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_linux_virtual_machine" "jenkins_vm" {
  name                  = "jenkins-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.example.id]
   size               = "Standard_DS1_v2"

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    name              = "jenkins-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  computer_name                   = "jenkinvm"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }

   tags = {
     environment = "staging"
   }
}

resource "null_resource" "jenkins_provisioner" {
  connection {
    type        = "ssh"
    host        = azurerm_linux_virtual_machine.jenkins_vm.public_ip_address
    user        = "azureuser"
    private_key = tls_private_key.example_ssh.private_key_pem
  }

   provisioner "file" {
    source      = "install.sh"
    destination = "/tmp/install.sh"
  }


  provisioner "remote-exec" {

    inline = [
        "chmod +x /tmp/install.sh",
        "/tmp/install.sh"
    ]
  }
}
