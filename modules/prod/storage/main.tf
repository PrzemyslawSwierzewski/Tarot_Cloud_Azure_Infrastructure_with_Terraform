resource "azurerm_storage_account" "monitoring" {
  name                     = local.storage_account_name
  resource_group_name      = var.tarot_cloud_rg_name
  location                 = var.rg_location
  account_tier             = local.SA_account_tier
  account_replication_type = local.SA_account_replication_type

  min_tls_version = local.min_tls_version

  tags = {
    Environment = local.environment
  }
}

resource "azurerm_storage_container" "monitoring_container" {
  name                  = local.container_name
  storage_account_id    = azurerm_storage_account.monitoring.id
  container_access_type = local.container_access_type
}