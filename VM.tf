resource "azurerm_network_interface" "example" {
  name                = "vm-chabbi950_z1"
  location            = "westeurope"
  resource_group_name = "myResourceGroup-chabbi"
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id            = "/subscriptions/8fdfcd42-cb6a-4f09-bd1d-984a332c84b1/resourceGroups/myResourceGroup-chabbi/providers/Microsoft.Network/virtualNetworks/myVNet-chabbi/subnets/myBackendSubnet-chabbi"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "vm-chabbi"
  resource_group_name = "myResourceGroup-chabbi"
  location            = "westeurope"
  size                = "Standard_DS1_v2"
  admin_username      = "chabbi"
  admin_password = "Password123"
  disable_password_authentication = false
  #private_ip_address = "10.21.1.4"
  #private_ip_addresses = ["10.21.1.4"]

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb = 30
    name = "vm-chabbi_OsDisk_1_b2a3cbd186574a029b7e4cef42a05b26"
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}