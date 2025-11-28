output "vmss_id" {
  description = "The ID of the Linux virtual machine scale set"
  value       = azurerm_linux_virtual_machine_scale_set.tarot_cloud_linux_vmss.id
}

output "vmss_name" {
  description = "The name of the Linux virtual machine scale set"
  value       = azurerm_linux_virtual_machine_scale_set.tarot_cloud_linux_vmss.name
}

output "vmss_identity_object_id" {
  description = "The object ID of the VMSS managed identity."
  value       = azurerm_linux_virtual_machine_scale_set.tarot_cloud_linux_vmss.identity.principal_id
}