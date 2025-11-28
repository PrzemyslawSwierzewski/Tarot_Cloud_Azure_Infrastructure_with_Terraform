output "key_vault_name" {
  description = "The name of the Key Vault."
  value       = azurerm_key_vault.postgres-keyvault.name
}
