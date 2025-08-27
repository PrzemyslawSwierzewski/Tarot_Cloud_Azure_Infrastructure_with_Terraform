resource "azurerm_virtual_network" "tarot_cloud_vnet" {
  name                = "${var.vnet_name}-${var.environment}"
  address_space       = [local.vnet.vnet1.address_space]
  location            = var.rg_location
  resource_group_name = var.tarot_cloud_rg_name

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_subnet" "tarot_cloud_subnet" {
  name                 = "${var.subnet_name}-${var.environment}"
  resource_group_name  = var.tarot_cloud_rg_name
  virtual_network_name = azurerm_virtual_network.tarot_cloud_vnet.name
  address_prefixes     = [local.vnet.vnet1.subnet_prefix]

  depends_on = [
    azurerm_virtual_network.tarot_cloud_vnet
  ]
}

resource "azurerm_public_ip" "tarot_cloud_public_ip" {
  name                = "${var.public_ip_name}-${var.environment}"
  resource_group_name = var.tarot_cloud_rg_name
  location            = var.rg_location
  allocation_method   = "Static"

  depends_on = [
    azurerm_subnet.tarot_cloud_subnet
  ]

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_network_interface" "tarot_cloud_nic" {
  name                = "${var.nic_name}-${var.environment}"
  location            = var.rg_location
  resource_group_name = var.tarot_cloud_rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.tarot_cloud_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tarot_cloud_public_ip.id
  }

  depends_on = [
    azurerm_subnet.tarot_cloud_subnet,
    azurerm_public_ip.tarot_cloud_public_ip
  ]

  tags = {
    Environment = var.environment
  }
}