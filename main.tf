# Create resource groups for all environments
resource "azurerm_resource_group" "tarot_cloud_rg" {
  for_each = local.environments

  name     = each.value.rg_name
  location = local.rg_location

  tags = {
    Environment = each.value.env_tag
  }
}

# Dev Networking Module
module "dev_networking" {
  source              = "./modules/dev/networking"
  tarot_cloud_rg_name = local.resource_group_name_dev
  rg_location         = local.rg_location

  depends_on = [azurerm_resource_group.tarot_cloud_rg["dev"]]
}

# Dev Compute Module
module "dev_compute" {
  source              = "./modules/dev/compute"
  tarot_cloud_rg_name = local.resource_group_name_dev
  rg_location         = local.rg_location
  tarot_cloud_nic     = module.dev_networking.tarot_cloud_nic
  ssh_public_key      = var.ssh_public_key

  depends_on = [module.dev_networking]
}

# Dev Security Module
module "dev_security" {
  source               = "./modules/dev/security"
  tarot_cloud_rg_name  = local.resource_group_name_dev
  rg_location          = local.rg_location
  subnets              = module.dev_networking.tarot_cloud_subnet_ids
  my_public_ip_address = var.my_public_ip_address

  depends_on = [module.dev_networking]
}

# Prod Networking Module
module "prod_networking" {
  source              = "./modules/prod/networking"
  tarot_cloud_rg_name = local.resource_group_name_prod
  rg_location         = local.rg_location

  depends_on = [azurerm_resource_group.tarot_cloud_rg["prod"]]
}

# Prod Compute Module
module "prod_compute" {
  source              = "./modules/prod/compute"
  tarot_cloud_rg_name = local.resource_group_name_prod
  rg_location         = local.rg_location
  //tarot_cloud_nic     = module.prod_networking.tarot_cloud_nic
  ssh_public_key      = var.ssh_public_key
  vmss_subnet_id      = module.prod_networking.vmss_subnet_id
  backend_pool_ids    = module.prod_networking.backend_pool
  owner_email_address = var.owner_email_address

  depends_on = [module.prod_networking]
}

# Prod Security Module
module "prod_security" {
  source               = "./modules/prod/security"
  tarot_cloud_rg_name  = local.resource_group_name_prod
  rg_location          = local.rg_location
  vmss_subnet_id       = module.prod_networking.vmss_subnet_id
  my_public_ip_address = var.my_public_ip_address

  depends_on = [module.prod_networking]
}

# Prod-only Monitoring Module
module "prod_monitoring" {
  source              = "./modules/prod/monitoring"
  tarot_cloud_rg_name = local.resource_group_name_prod
  rg_location         = local.rg_location
  vmss_id             = module.prod_compute.vmss_id
  owner_email_address = var.owner_email_address
  vmss_name           = module.prod_compute.vmss_name

  depends_on = [
    azurerm_resource_group.tarot_cloud_rg["prod"],
    module.prod_compute
  ]
}

# Prod-only Postgres Module
module "prod_postgres" {
  source                    = "./modules/prod/postgres"
  tarot_cloud_rg_name       = local.resource_group_name_prod
  rg_location               = local.rg_location
  postgres_subnet_id        = module.prod_networking.postgres_subnet
  postgresql_admin_password = var.postgresql_admin_password
  my_public_ip_address      = var.my_public_ip_address
  private_dns_zone_id       = module.prod_networking.private_dns_zone_id

  depends_on = [
    module.prod_networking,
    azurerm_resource_group.tarot_cloud_rg["prod"]
  ]
}