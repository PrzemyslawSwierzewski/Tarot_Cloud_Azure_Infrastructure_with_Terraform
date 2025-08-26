# Dev ENV
resource "azurerm_resource_group" "tarot_cloud_rg_dev" {
  name     = local.resource_group_name_dev
  location = local.rg_location

  tags = {
    Environment = local.dev_environment
  }
}

module "dev_networking" {
  source = "./modules/dev/networking"

  tarot_cloud_rg_name = local.resource_group_name_dev
  rg_location         = local.rg_location

  depends_on = [azurerm_resource_group.tarot_cloud_rg_dev]
}

module "dev_compute" {
  source = "./modules/dev/compute"

  tarot_cloud_rg_name = local.resource_group_name_dev
  rg_location         = local.rg_location
  tarot_cloud_nic     = [for nic_key, nic_id in module.dev_networking.tarot_cloud_nic : nic_id]
  ssh_public_key      = var.ssh_public_key


  depends_on = [module.dev_networking]
}

module "dev_security" {
  source               = "./modules/dev/security"
  tarot_cloud_rg_name  = local.resource_group_name_dev
  rg_location          = local.rg_location
  subnets              = module.dev_networking.tarot_cloud_subnet_ids
  vnets                = module.dev_networking.vnets
  my_public_ip_address = var.my_public_ip_address

  depends_on = [module.dev_networking]
}
#Prod ENV
resource "azurerm_resource_group" "tarot_cloud_rg_prod" {
  name     = local.resource_group_name_prod
  location = local.rg_location

  tags = {
    Environment = local.prod_environment
  }
}

module "prod_networking" {
  source = "./modules/prod/networking"

  tarot_cloud_rg_name = local.resource_group_name_prod
  rg_location         = local.rg_location

  depends_on = [azurerm_resource_group.tarot_cloud_rg_prod]
}

module "prod_compute" {
  source = "./modules/prod/compute"

  tarot_cloud_rg_name = local.resource_group_name_prod
  rg_location         = local.rg_location
  tarot_cloud_nic     = [for nic_key, nic_id in module.prod_networking.tarot_cloud_nic : nic_id]
  ssh_public_key      = var.ssh_public_key


  depends_on = [module.prod_networking]
}

module "prod_security" {
  source               = "./modules/prod/security"
  tarot_cloud_rg_name  = local.resource_group_name_prod
  rg_location          = local.rg_location
  subnets              = module.prod_networking.tarot_cloud_subnet_ids
  vnets                = module.prod_networking.vnets
  my_public_ip_address = var.my_public_ip_address

  depends_on = [module.prod_networking]
}

module "prod_monitoring" {
  source = "./modules/prod/monitoring"

  tarot_cloud_rg_name = local.resource_group_name_prod
  rg_location         = local.rg_location
  vm_id               = module.prod_compute.vm_id
  owner_email_address = var.owner_email_address
  vm_name             = module.prod_compute.vm_name

  depends_on = [azurerm_resource_group.tarot_cloud_rg_prod, module.prod_compute]
}