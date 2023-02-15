resource "azurerm_firewall" "example" {
  name                = "firewall-chabbi"
  location            = "westeurope"
  resource_group_name = "myResourceGroup-chabbi"
  sku_name = "AZFW_VNet"
  sku_tier = "Standard"

  threat_intel_mode = "Alert"

  ip_configuration {
    name                 = "AzureFirewallSubnet"
    public_ip_address_id = "/subscriptions/8fdfcd42-cb6a-4f09-bd1d-984a332c84b1/resourceGroups/myResourceGroup-chabbi/providers/Microsoft.Network/publicIPAddresses/chabbi-ip"
    subnet_id            = "/subscriptions/8fdfcd42-cb6a-4f09-bd1d-984a332c84b1/resourceGroups/myResourceGroup-chabbi/providers/Microsoft.Network/virtualNetworks/myVNet-chabbi/subnets/AzureFirewallSubnet"
  }
}
