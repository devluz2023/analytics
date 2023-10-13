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


# Rule to allow incoming traffic on port 8080
resource "azurerm_network_security_rule" "https" {
  name                        = "allow-https"
  priority                    = 1004
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.analytics-security-grup.name
}



# resource "azurerm_dns_zone" "example" {
#   name                = "faluz.com"
#   resource_group_name         = azurerm_resource_group.rg.name
# }

# resource "azurerm_dns_a_record" "example" {
#   name                = "test"
#   zone_name           = azurerm_dns_zone.example.name
#   resource_group_name         = azurerm_resource_group.rg.name
#   ttl                 = 300
#  records              = [azurerm_public_ip.analytics-public-ip.ip_address]  # Use o IP público da sua VM

# }


