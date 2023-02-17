# Create the resource group
resource "azurerm_resource_group" "rg1" {
  name     = "myResourceGroup-chabbi"
  location = "westeurope"
}
