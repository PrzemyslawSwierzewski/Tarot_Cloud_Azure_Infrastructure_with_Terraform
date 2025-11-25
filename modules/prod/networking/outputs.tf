# output "tarot_cloud_nic" {
#   value = [azurerm_network_interface.tarot_cloud_nic.id]
# }

output "tarot_cloud_public_ip" {
  value = [azurerm_public_ip.tarot_cloud_public_ip.ip_address]
}

output "tarot_cloud_subnet_ids" {
  value = [azurerm_subnet.tarot_cloud_subnet.id]
}

output "vnets" {
  value = [azurerm_virtual_network.tarot_cloud_vnet.id]
}

output "subnet" {
  value = azurerm_subnet.tarot_cloud_subnet.id
}

output "backend_pool" {
  value = [azurerm_lb_backend_address_pool.backend_pool.id]
}

output "private_dns_zone" {
  value = azurerm_private_dns_zone.dns_zone_for_postgresql_server
}

output "private_dns_zone_id" {
  value = azurerm_private_dns_zone.dns_zone_for_postgresql_server.id
}