resource "azurerm_virtual_network" "tarot_cloud_vnet" {
  for_each            = local.vnets
  name                = "${local.tarot_cloud_network_name}-${replace(each.value.address_space, "/", "-")}"
  address_space       = [each.value.address_space]
  location            = local.resources_location
  resource_group_name = var.tarot_cloud_rg_name

}

resource "azurerm_subnet" "tarot_cloud_subnet" {
  for_each = local.vnets

  name                 = "${local.tarot_cloud_subnet_name}-${replace(each.value.subnet_prefix, "/", "-")}"
  resource_group_name  = var.tarot_cloud_rg_name
  virtual_network_name = azurerm_virtual_network.tarot_cloud_vnet[each.key].name
  address_prefixes     = [each.value.subnet_prefix]

  depends_on = [
    azurerm_virtual_network.tarot_cloud_vnet
  ]
}

resource "azurerm_public_ip" "tarot_cloud_public_ip" {
  for_each = azurerm_subnet.tarot_cloud_subnet

  name                = "${local.public_ip_name}-${each.key}"
  resource_group_name = var.tarot_cloud_rg_name
  location            = local.resources_location
  allocation_method   = "Static"

  depends_on = [
    azurerm_subnet.tarot_cloud_subnet
  ]
}

resource "azurerm_network_interface" "tarot_cloud_nic" {
  for_each = azurerm_subnet.tarot_cloud_subnet

  name                = "${local.tarot_cloud_nic_name}-${each.key}"
  location            = local.resources_location
  resource_group_name = var.tarot_cloud_rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = each.value.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tarot_cloud_public_ip[each.key].id
  }

  depends_on = [
    azurerm_subnet.tarot_cloud_subnet,
    azurerm_public_ip.tarot_cloud_public_ip
  ]
}

resource "azurerm_network_security_group" "tarot_cloud_nsg" {
  for_each            = local.vnets

  name                = "${local.network_security_group_name}-${each.key}"
  location            = local.resources_location
  resource_group_name = local.resource_group_name

  dynamic "security_rule" {
    for_each = flatten([for group in local.security_rules : values(group)])
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
  for_each = azurerm_subnet.tarot_cloud_subnet

  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.tarot_cloud_nsg[each.key].id

  depends_on = [
    azurerm_subnet.tarot_cloud_subnet,
    azurerm_network_security_group.tarot_cloud_nsg
  ]
}
