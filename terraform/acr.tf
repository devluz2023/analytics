

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

