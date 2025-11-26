resource "azurerm_virtual_network" "tarot_cloud_vnet" {
  name                = "${local.tarot_cloud_network_name}-${local.environment}"
  address_space       = [local.vnet.vnet1.address_space]
  location            = local.resources_location
  resource_group_name = var.tarot_cloud_rg_name

  tags = {
    Environment = local.environment
  }
}

resource "azurerm_subnet" "vmss_subnet" {
  name                 = "${local.vmss_subnet_name}-${local.environment}"
  resource_group_name  = var.tarot_cloud_rg_name
  virtual_network_name = azurerm_virtual_network.tarot_cloud_vnet.name
  address_prefixes     = [local.vnet.vnet1.subnet_prefix_vmss]
}

resource "azurerm_subnet" "postgres_subnet" {
  name                 = "${local.postgres_subnet_name}-${local.environment}"
  resource_group_name  = var.tarot_cloud_rg_name
  virtual_network_name = azurerm_virtual_network.tarot_cloud_vnet.name
  address_prefixes     = [local.vnet.vnet1.subnet_prefix_postgres]

  delegation {
    name = "postgresqldelegation"
    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_public_ip" "tarot_cloud_public_ip" {
  name                = "${local.public_ip_name}-${local.environment}"
  resource_group_name = var.tarot_cloud_rg_name
  location            = local.resources_location
  allocation_method   = "Static"

  tags = {
    Environment = local.environment
  }
}

resource "azurerm_lb" "vmss_lb" {
  name                = "${local.load_balancer_name}-${local.environment}"
  location            = local.resources_location
  resource_group_name = var.tarot_cloud_rg_name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.tarot_cloud_public_ip.id
  }

  tags = {
    Environment = local.environment
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id = azurerm_lb.vmss_lb.id
  name            = local.backend_pool_name
}

resource "azurerm_lb_probe" "http" {
  loadbalancer_id = azurerm_lb.vmss_lb.id
  name            = local.lb_probe_name
  port            = 80
  protocol        = "Tcp"
}

resource "azurerm_lb_rule" "http" {
  loadbalancer_id                = azurerm_lb.vmss_lb.id
  name                           = local.lb_rule_name
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.http.id
}

resource "azurerm_private_dns_zone" "dns_zone_for_postgresql_server" {
  name                = local.postgres_private_dns_zone_name
  resource_group_name = var.tarot_cloud_rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres_dns_zone_link" {
  name                  = "postgres-dnszone-${local.environment}-link"
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone_for_postgresql_server.name
  virtual_network_id    = azurerm_virtual_network.tarot_cloud_vnet.id
  resource_group_name   = var.tarot_cloud_rg_name
  depends_on            = [azurerm_subnet.postgres_subnet]
}