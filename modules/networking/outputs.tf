output "tarot_cloud_nic" {
  value = { for k, nic in azurerm_network_interface.tarot_cloud_nic : k => nic.id }
}

output "tarot_cloud_public_ip" {
  value = { for k, ip in azurerm_public_ip.tarot_cloud_public_ip : k => ip.ip_address }
}