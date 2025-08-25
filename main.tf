resource "azurerm_resource_group" "tarot_cloud_rg" {
  name     = local.resource_group_name
  location = local.rg_location
}

module "networking" {
  source = "./modules/networking"

  tarot_cloud_rg_name = local.resource_group_name
  rg_location         = local.rg_location

}