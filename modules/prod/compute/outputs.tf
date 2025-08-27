output "vm_id" {
  description = "The ID of the Linux virtual machine"
  value       = azurerm_linux_virtual_machine.tarot_cloud_linux_vm.id
}

output "vm_name" {
  description = "The name of the Linux virtual machine"
  value       = azurerm_linux_virtual_machine.tarot_cloud_linux_vm.name
}