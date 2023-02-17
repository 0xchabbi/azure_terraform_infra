resource "azurerm_virtual_network" "vnet1" {
  name                = "myVNet-chabbi"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  address_space       = ["10.21.0.0/16"]
}

resource "azurerm_subnet" "frontend" {
  name                 = "myAGSubnet-chabbi"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.21.0.0/24"]
}

resource "azurerm_subnet" "backend" {
  name                 = "myBackendSubnet-chabbi"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.21.1.0/24"]

  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.Web",
  ]

}

resource "azurerm_subnet" "az-fw-subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.21.1.0/24"]

  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.Web",
  ]
}

resource "azurerm_public_ip" "pip1" {
  name                = "myAGPublicIPAddress-chabbi"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "webapp1-chabbi"
}
