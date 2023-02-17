resource "azurerm_network_interface" "example" {
  name                = "vm-chabbi950_z1"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.backend.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_disk_encryption_set" "des" {
  name                = "des"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  key_vault_key_id    = azurerm_key_vault_key.des-key.id

  identity {
    type = "SystemAssigned"
  }
}


resource "azurerm_linux_virtual_machine" "example" {
  name                            = "vm-chabbi"
  resource_group_name             = azurerm_resource_group.rg1.name
  location                        = azurerm_resource_group.rg1.location
  size                            = "Standard_DS1_v2"
  admin_username                  = "chabbi"
  admin_password                  = var.admin_pass
  disable_password_authentication = false
  encryption_at_host_enabled      = true

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching                = "ReadWrite"
    storage_account_type   = "Premium_LRS"
    disk_size_gb           = 30
    name                   = "vm-chabbi_OsDisk_1_b2a3cbd186574a029b7e4cef42a05b26"
    disk_encryption_set_id = azurerm_disk_encryption_set.des.id
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}
