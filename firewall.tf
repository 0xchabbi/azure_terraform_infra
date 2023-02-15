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


resource "azurerm_route_table" "example" {
  name                          = "route-chabbi"
  location                      = "westeurope"
  resource_group_name           = "myResourceGroup-chabbi"
  disable_bgp_route_propagation = false

  route {
    name           = "chabbi-route"
    address_prefix = "0.0.0.0/0"
    next_hop_in_ip_address = "10.21.3.4"
    next_hop_type  = "VirtualAppliance"
  }
}

resource "azurerm_firewall_policy" "example" {
  name                = "pol-chabbi"
  resource_group_name = "myResourceGroup-chabbi"
  location            = "westeurope"
}