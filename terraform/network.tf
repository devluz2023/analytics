resource "azurerm_virtual_network" "analytics" {
  name                = "analytics-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}



resource "azurerm_subnet" "analytics" {
  name                 = "analytics-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.analytics.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "analytics" {
  name                = "analytics-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.analytics.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id           = azurerm_public_ip.analytics-public-ip.id  # Associate with the public IP
  }
}


resource "azurerm_public_ip" "analytics-public-ip" {
  name                = "analytic-vm-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"  # You can use "Static" if needed
}


resource "azurerm_network_security_group" "analytics-security-grup" {
  name                = "analytics-security-grup"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}



# Rule to allow incoming traffic on port 22 (SSH)
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
  network_security_group_name = azurerm_network_security_group.analytics-security-grup.name
  
}

# Rule to allow incoming traffic on port 1433 (SQL Server)
resource "azurerm_network_security_rule" "sql" {
  name                        = "allow-sql"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1433"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.analytics-security-grup.name
}

# Rule to allow incoming traffic on port 8080
resource "azurerm_network_security_rule" "http" {
  name                        = "allow-http"
  priority                    = 1003
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.analytics-security-grup.name
}



# resource "azurerm_security_center_jit_network_access_policy" "example" {
#   resource_group_name = "my-rg"  # Replace with your resource group name
#   vm_id              = azurerm_virtual_machine.ubuntu-machine.id

#   ports {
#     number   = 22  # SSH port
#     protocol = "Tcp"
#   }

#   // Specify the allowed IP addresses or ranges for JIT access
#   // Replace these with your desired IP addresses or ranges
#   source_addresses = ["0.0.0.0/0"]
  
#   // Specify the maximum request time (in minutes)
#   // Adjust this value based on your requirements
#   max_request_time = 60
# }
