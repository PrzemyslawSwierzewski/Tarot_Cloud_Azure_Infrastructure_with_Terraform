data "azurerm_role_definition" "sa_contributor" {
  name = "Storage Blob Data contributor"
}

resource "azurerm_role_assignment" "sa_contributor_assigment" {
  scope              = var.storage_account_id
  role_definition_id = data.azurerm_role_definition.sa_contributor.id
  principal_id       = var.vm_identity
}
