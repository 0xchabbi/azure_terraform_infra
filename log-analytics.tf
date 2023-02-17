resource "azurerm_log_analytics_workspace" "prod" {
  name                = "log-analytics-prod"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}