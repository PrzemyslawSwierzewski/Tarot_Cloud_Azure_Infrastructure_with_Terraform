data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "postgres-keyvault" {
  name                       = var.key_vault_name
  location                   = var.rg_location
  resource_group_name        = var.tarot_cloud_rg_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = true

  tags = {
    Environment = var.environment
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]
  }

  # VMSS Managed Identity
  # to allow it to retrieve secrets.
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = var.vmss_identity_object_id

    secret_permissions = [
      "Get",
      "List"
    ]
  }
}

resource "azurerm_key_vault_secret" "postgres-password" {
  name         = "postgres-password"
  value        = var.postgresql_admin_password
  key_vault_id = azurerm_key_vault.postgres-keyvault.id
}