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