resource "azurerm_virtual_network" "tarot_cloud_vnet" {
  for_each            = local.vnets #For a purpose of learning I'm using "for_each" to create a couple of virtual networks
  name                = "${local.tarot_cloud_network_name}-${replace(each.value.address_space, "/", "-")}" #Replacing / with - in the name, cuz azure validation is not accepting /
  address_space       = [each.value.address_space]
  location            = local.resources_location
  resource_group_name = var.tarot_cloud_rg_name
}

resource "azurerm_subnet" "tarot_cloud_subnet" {
  for_each = local.vnets

  name                 = "${local.tarot_cloud_subnet_name}-${replace(each.value.subnet_prefix, "/", "-")}"
  resource_group_name  = var.tarot_cloud_rg_name
  virtual_network_name = azurerm_virtual_network.tarot_cloud_vnet[each.key].name #Each virtual network will get his own subnet
  address_prefixes     = [each.value.subnet_prefix] #Each subnet will get his own address prefix
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
}

resource "azurerm_public_ip" "tarot_cloud_public_ip" {
  for_each = azurerm_subnet.tarot_cloud_subnet

  name                = "${local.public_ip_name}-${each.key}"
  resource_group_name = var.tarot_cloud_rg_name
  location            = local.resources_location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}