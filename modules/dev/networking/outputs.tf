output "tarot_cloud_nic" {
  description = "The ID of the network interface"
  value       = [azurerm_network_interface.tarot_cloud_nic.id]
}

output "tarot_cloud_public_ip" {
  description = "The public IP address"
  value       = [azurerm_public_ip.tarot_cloud_public_ip.ip_address]
}

output "tarot_cloud_subnet_ids" {
  description = "The subnet IDs"
  value       = [azurerm_subnet.tarot_cloud_subnet.id]
}

output "vnets" {
  description = "The virtual network IDs"
  value       = [azurerm_virtual_network.tarot_cloud_vnet.id]
}

output "subnets" {
  description = "The subnet IDs (duplicate for compatibility)"
  value       = [azurerm_subnet.tarot_cloud_subnet.id]
}