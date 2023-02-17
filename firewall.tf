resource "azurerm_firewall" "vm-fw" {
  name                = "firewall-chabbi"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  threat_intel_mode = "Alert"

  ip_configuration {
    name                 = "AzureFirewallSubnet"
    public_ip_address_id = azurerm_public_ip.pip1.id
    subnet_id            = azurerm_subnet.az-fw-subnet.id
  }
}

resource "azurerm_firewall_policy" "vm-policy" {
  name                     = "pol-chabbi"
  resource_group_name      = azurerm_resource_group.rg1.name
  location                 = azurerm_resource_group.rg1.location
  threat_intelligence_mode = "Alert"
}
