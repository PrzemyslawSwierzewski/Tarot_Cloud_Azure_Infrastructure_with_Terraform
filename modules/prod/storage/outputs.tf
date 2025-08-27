output "storage_account_id" {
  value = azurerm_storage_account.monitoring.id
}

output "sa_container_name" {
  value = azurerm_storage_container.monitoring_container.name
}