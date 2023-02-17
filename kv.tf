resource "azurerm_key_vault" "my-kv" {
  name = "my-kv"
  location = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name = "standard"
  enabled_for_disk_encryption = true
  purge_protection_enabled = true
}

resource "azurerm_key_vault_access_policy" "des-disk" {
  key_vault_id = azurerm_key_vault.my-kv.id

  tenant_id = azurerm_disk_encryption_set.des.identity.0.tenant_id
  object_id = azurerm_disk_encryption_set.des.identity.0.principal_id

  key_permissions = [
    "Create",
    "Delete",
    "Get",
    "Purge",
    "Recover",
    "Update",
    "List",
    "Decrypt",
    "Sign"
  ]
}


resource "azurerm_key_vault_access_policy" "des-user" {
  key_vault_id = azurerm_key_vault.my-kv.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Create",
    "Delete",
    "Get",
    "Purge",
    "Recover",
    "Update",
    "List",
    "Decrypt",
    "Sign"
  ]
}

resource "azurerm_key_vault_key" "des-key" {
  name         = "des-key"
  key_vault_id = azurerm_key_vault.my-kv.id
  key_type     = "RSA"
  key_size     = 2048

  depends_on = [
    azurerm_key_vault_access_policy.des-user
  ]

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

resource "azurerm_role_assignment" "des-disk" {
  scope                = azurerm_key_vault.my-kv.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_disk_encryption_set.des.identity.0.principal_id
}
