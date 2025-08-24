output "tarot_cloud_public_ip" {
  value = { for k, PIP in azurerm_public_ip.tarot_cloud_public_ip : k => PIP.ip_address }
}