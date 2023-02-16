resource "azurerm_firewall" "example" {
  name                = "firewall-chabbi"
  location            = "westeurope"
  resource_group_name = "myResourceGroup-chabbi"
  sku_name = "AZFW_VNet"
  sku_tier = "Standard"

  threat_intel_mode = "Alert"

   /*dynamic {
    for_each = azurerm_virtual_network.vnet1.subnet
    content {
      name                       = "vnet-${each.value.name}"
      address_prefix             = each.value.address_prefix
      use_network_watcher        = false
      use_public_ip_address      = false
      is_managed                 = true
      threat_intel_mode_enabled  = false
      threat_intel_alert_enabled = false
    }
  }*/

    ip_configuration {
    name                 = "AzureFirewallSubnet"
    public_ip_address_id = "/subscriptions/8fdfcd42-cb6a-4f09-bd1d-984a332c84b1/resourceGroups/myResourceGroup-chabbi/providers/Microsoft.Network/publicIPAddresses/chabbi-ip"
    subnet_id            = "/subscriptions/8fdfcd42-cb6a-4f09-bd1d-984a332c84b1/resourceGroups/myResourceGroup-chabbi/providers/Microsoft.Network/virtualNetworks/myVNet-chabbi/subnets/AzureFirewallSubnet"
  }

}


/*resource "azurerm_route_table" "example" {
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
}*/

resource "azurerm_firewall_policy" "example" {
  name                = "pol-chabbi"
  resource_group_name = "myResourceGroup-chabbi"
  location            = "westeurope"
  /*rule_collection_groups = [
        "/subscriptions/8fdfcd42-cb6a-4f09-bd1d-984a332c84b1/resourcegroups/myResourceGroup-chabbi/providers/Microsoft.Network/firewallPolicies/pol-chabbi/ruleCollectionGroups/DefaultApplicationRuleCollectionGroup", 
        "/subscriptions/8fdfcd42-cb6a-4f09-bd1d-984a332c84b1/resourcegroups/myResourceGroup-chabbi/providers/Microsoft.Network/firewallPolicies/pol-chabbi/ruleCollectionGroups/DefaultNetworkRuleCollectionGroup",     
        "/subscriptions/8fdfcd42-cb6a-4f09-bd1d-984a332c84b1/resourcegroups/myResourceGroup-chabbi/providers/Microsoft.Network/firewallPolicies/pol-chabbi/ruleCollectionGroups/DefaultDnatRuleCollectionGroup",   
  ]*/
  threat_intelligence_mode = "Alert"
}

/*resource "azurerm_firewall_network_rule_collection" "firewall_rules" {
  name                = "firewall-rules"
  priority            = 100
  action              = "Allow"
  protocol            = "Tcp"
  source_addresses    = ["Internet"]
  destination_ports   = ["3389"]
  resource_group_name = "myResourceGroup-chabbi"
  firewall_name       = "firewall-chabbi"
}

resource "azurerm_firewall_nat_rule_collection" "nat_rule" {
  name                = "nat-rule"
  priority            = 100
  action              = "Dnat"
  source_addresses    = ["*"]
  destination_addresses = ["${azurerm_public_ip.firewall.ip_address}"]
  destination_ports   = ["3389"]
  translated_address = "${azurerm_virtual_network.vnet.subnet.0.address_prefix}"
  translated_port = "3389"
  resource_group_name = "myResourceGroup-chabbi"
  firewall_name       = "firewall-chabbi"
}*/



/*resource "azurerm_public_ip" "example" {
  name                = "firewall-pip"
  location            = "westeurope"
  resource_group_name = "myResourceGroup-chabbi"

  allocation_method = "Static"
  sku               = "Standard"
  tags = {
    environment = "dev"
  }
}*/
