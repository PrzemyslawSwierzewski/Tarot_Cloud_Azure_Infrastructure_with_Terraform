output "tarot_cloud_nic" {
  value = { for k, nic in azurerm_network_interface.tarot_cloud_nic : k => nic.id }
}

output "tarot_cloud_public_ip" {
  value = { for k, ip in azurerm_public_ip.tarot_cloud_public_ip : k => ip.ip_address }
}

output "tarot_cloud_subnet_ids" {
  value = { for k, subnet in azurerm_subnet.tarot_cloud_subnet : k => subnet.id }
}

output "vnets" {
  value = { for k, vnet in azurerm_virtual_network.tarot_cloud_vnet : k => vnet.id }
}

output "subnets" {
  value = { for k, subnet in azurerm_subnet.tarot_cloud_subnet : k => subnet.id }
}