resource "azurerm_resource_group" "tarot_cloud_rg" {
  name     = local.resource_group_name
  location = local.rg_location
}

module "networking" {
  source = "./modules/networking"

  tarot_cloud_rg_name = local.resource_group_name
  rg_location         = local.rg_location

  depends_on = [azurerm_resource_group.tarot_cloud_rg]
}

module "compute" {
  source = "./modules/compute"

  tarot_cloud_rg_name = local.resource_group_name
  rg_location         = local.rg_location
  tarot_cloud_nic     = [for nic_key, nic_id in module.networking.tarot_cloud_nic : nic_id]
  ssh_public_key = var.ssh_public_key


  depends_on = [module.networking]
}

module "security" {
  source     = "./modules/security"
  tarot_cloud_rg_name    = local.resource_group_name
  rg_location = local.rg_location
  subnets    = module.networking.tarot_cloud_subnet_ids
  vnets = module.networking.vnets

  depends_on = [module.networking]
}
