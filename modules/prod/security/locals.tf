locals {
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
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
      }
      Allow443port = {
        name                       = "Allow443port"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "Internet"
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
        source_address_prefix      = var.my_public_ip_address
        destination_address_prefix = "*"
      }
    }

    Outbound = {
      Allow443port = {
        name                       = "Allow443"
        priority                   = 103
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*" // To be replaced with "Internet" as right now I'm checking if trivy works
      }
      Allow80port = {
        name                       = "Allow80"
        priority                   = 104
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "Internet"
      }
      Allow_ssh_to_my_machine = {
        name                       = "Allow_ssh_to_my_machine"
        priority                   = 105
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = var.my_public_ip_address
      }
    }
  }
}