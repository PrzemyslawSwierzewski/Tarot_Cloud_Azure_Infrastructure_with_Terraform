locals {
  resource_group_name = "Tarot-cloud"
  resources_location         = "East US"
  vnets = {
    vnet1 = {
      address_space = "10.0.0.0/16",
      subnet_prefix = "10.0.1.0/24"
    }
    vnet2 = {
      address_space = "10.1.0.0/16",
      subnet_prefix = "10.1.1.0/24"
    }
  }
  tarot_cloud_subnet_name              = "tarot-cloud-subnet"
  tarot_cloud_network_name = "tarot-cloud-network"
  tarot_cloud_nic_name = "tarot-cloud-nic"
  public_ip_name = "tarot-cloud-public-ip"
  network_security_group_name = "tarot-cloud-nsg"
  security_rules = {
    Inbound = {
      Allow80port = {
        name                       = "Allow80port"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      Allow443port = {
        name                       = "Allow443port"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
      Allow22port = {
        name                       = "Allow22port"
        priority                   = 102
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    }
    Outbound = {
      AllowAll = {
        name                       = "AllowAll"
        priority                   = 100
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    }
  }
}

