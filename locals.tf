locals {
  resource_group_name = "Tarot-cloud"
  rg_location         = "East US"
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
}