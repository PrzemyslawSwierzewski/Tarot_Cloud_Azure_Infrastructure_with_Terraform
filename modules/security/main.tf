resource "azurerm_network_security_group" "tarot_cloud_nsg" {
  for_each            = var.vnets

  name                = "${local.network_security_group_name}-${each.key}"
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
}

resource "azurerm_subnet_network_security_group_association" "tarot_cloud_assoc" {
  for_each = var.subnets

  subnet_id                 = each.value
  network_security_group_id = azurerm_network_security_group.tarot_cloud_nsg[each.key].id

  depends_on = [
    azurerm_network_security_group.tarot_cloud_nsg
  ]
}