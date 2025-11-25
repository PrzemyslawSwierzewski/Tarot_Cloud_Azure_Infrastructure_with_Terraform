resource "azurerm_postgresql_flexible_server" "tarot_postgresql_server" {
  name                          = "${local.environment}-tarot-psqlserver"
  resource_group_name           = var.tarot_cloud_rg_name
  location                      = var.rg_location
  version                       = "15"
  delegated_subnet_id           = var.subnet_id
  private_dns_zone_id           = var.private_dns_zone_id
  public_network_access_enabled = false
  administrator_login           = "psqladmin"
  administrator_password        = var.postgresql_admin_password
  zone                          = "1"

  storage_mb   = 32768
  storage_tier = "P4"

  sku_name = "B_Standard_B2s"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "admin_firewall_rule" {
  name             = "home_office"
  server_id        = azurerm_postgresql_flexible_server.tarot_postgresql_server.id
  start_ip_address = var.my_public_ip_address
  end_ip_address   = var.my_public_ip_address
}