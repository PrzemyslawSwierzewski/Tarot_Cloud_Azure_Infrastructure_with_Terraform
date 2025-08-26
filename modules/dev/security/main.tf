resource "azurerm_network_security_group" "tarot_cloud_nsg" {
  name                = "${local.network_security_group_name}-${local.environment}"
  location            = var.rg_location
  resource_group_name = var.tarot_cloud_rg_name

  dynamic "security_rule" {
    for_each = flatten([for group in var.security_rules : values(group)])
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }

  tags = {
    Environment = local.environment
  }
}

resource "azurerm_subnet_network_security_group_association" "tarot_cloud_assoc" {

  subnet_id                 = var.subnets[0]
  network_security_group_id = azurerm_network_security_group.tarot_cloud_nsg.id

  depends_on = [
    azurerm_network_security_group.tarot_cloud_nsg
  ]
}