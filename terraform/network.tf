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


resource "azurerm_network_security_rule" "redis" {
  name                        = "allow-redis"
  priority                    = 1016
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "6379" # Default port for Redis
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.analytics-security-grup.name

}

resource "azurerm_network_security_rule" "mongodb" {
  name                        = "allow-mongodb"
  priority                    = 1014
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "27017" # Default port for MongoDB
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.analytics-security-grup.name

}

resource "azurerm_network_security_rule" "oracle-database" {
  name                        = "allow-oracle"
  priority                    = 1005
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1521" # Default port for Oracle Database
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.analytics-security-grup.name

}

# Grafana typically runs on port 3000
resource "azurerm_network_security_rule" "grafana" {
  name                        = "allow-grafana"
  priority                    = 1006
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3000" # Default port for Grafana
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.analytics-security-grup.name

}

# Kibana typically runs on port 5601
resource "azurerm_network_security_rule" "kibana" {
  name                        = "allow-kibana"
  priority                    = 1007
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5601" # Default port for Kibana
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.analytics-security-grup.name

}

resource "azurerm_network_security_rule" "mysql" {
  name                        = "allow-mysql"
  priority                    = 1008
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3306" # Default port for MySQL
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


resource "azurerm_network_security_rule" "db2" {
  name                        = "allow-db2"
  priority                    = 1009
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "50000" # Default port for IBM DB2
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.analytics-security-grup.name
}

resource "azurerm_network_security_rule" "neo4j" {
  name                        = "allow-neo4j"
  priority                    = 1010
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "7687" # Default port for Neo4j Bolt protocol
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.analytics-security-grup.name
}

resource "azurerm_network_security_rule" "elasticsearch" {
  name                        = "allow-elasticsearch"
  priority                    = 1011
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "9200" # Default port for Elasticsearch HTTP API
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.analytics-security-grup.name
}

resource "azurerm_network_security_rule" "airflow" {
  name                        = "allow-airflow"
  priority                    = 1012
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080" # Default port for Apache Airflow web server
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.analytics-security-grup.name
}

resource "azurerm_network_security_rule" "mlflow" {
  name                        = "allow-mlflow"
  priority                    = 1013
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5000" # Default port for MLflow server
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.analytics-security-grup.name
}

resource "azurerm_network_security_rule" "jupyter" {
  name                        = "allow-jupyter"
  priority                    = 1015
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8888" # Default port for Jupyter Notebook server
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


