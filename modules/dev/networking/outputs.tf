output "tarot_cloud_nic" {
  value = [azurerm_network_interface.tarot_cloud_nic.id]
}

output "tarot_cloud_public_ip" {
  value = [azurerm_public_ip.tarot_cloud_public_ip.ip_address]
}

output "tarot_cloud_subnet_ids" {
  value = [azurerm_subnet.tarot_cloud_subnet.id]
}

output "vnets" {
  value = [azurerm_virtual_network.tarot_cloud_vnet.id]
}

output "subnets" {
  value = [azurerm_subnet.tarot_cloud_subnet.id]
}