resource "azurerm_virtual_network" "tarot_cloud_vnet" {
  name                = "${local.tarot_cloud_network_name}-${local.environment}"
  address_space       = [local.vnet.vnet1.address_space]
  location            = local.resources_location
  resource_group_name = var.tarot_cloud_rg_name

  tags = {
    Environment = local.environment
  }
}

resource "azurerm_subnet" "tarot_cloud_subnet" {
  name                 = "${local.tarot_cloud_subnet_name}-${local.environment}"
  resource_group_name  = var.tarot_cloud_rg_name
  virtual_network_name = azurerm_virtual_network.tarot_cloud_vnet.name
  address_prefixes     = [local.vnet.vnet1.subnet_prefix]

  depends_on = [
    azurerm_virtual_network.tarot_cloud_vnet
  ]
}

resource "azurerm_public_ip" "tarot_cloud_public_ip" {
  name                = "${local.public_ip_name}-${local.environment}"
  resource_group_name = var.tarot_cloud_rg_name
  location            = local.resources_location
  allocation_method   = "Static"

  depends_on = [
    azurerm_subnet.tarot_cloud_subnet
  ]

  tags = {
    Environment = local.environment
  }
}

resource "azurerm_lb" "vmss_lb" {
  name                = "ProdLoadBalancer"
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
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "http" {
  loadbalancer_id = azurerm_lb.vmss_lb.id
  name            = "http-probe"
  protocol        = "Tcp"
  port            = 80
}

resource "azurerm_lb_rule" "http" {
  loadbalancer_id                = azurerm_lb.vmss_lb.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.http.id
}