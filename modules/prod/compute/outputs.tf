output "vm_id" {
  value = azurerm_linux_virtual_machine.tarot_cloud_linux_VM.id
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.tarot_cloud_linux_VM.name
}

output "vm_identity" {
  value = azurerm_linux_virtual_machine.tarot_cloud_linux_VM.identity[0].principal_id
}