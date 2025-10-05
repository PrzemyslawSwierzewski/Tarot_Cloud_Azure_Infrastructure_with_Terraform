locals {
  resource_group_name_dev  = "Tarot-cloud-${local.dev_environment}"
  rg_location              = "East US"
  resource_group_name_prod = "Tarot-cloud-${local.prod_environment}"
  prod_environment         = "Production"
  dev_environment          = "Development"
  environments = {
    dev = {
      rg_name    = local.resource_group_name_dev
      module_dir = "./modules/dev"
      env_tag    = local.dev_environment
    }
    prod = {
      rg_name    = local.resource_group_name_prod
      module_dir = "./modules/prod"
      env_tag    = local.prod_environment
    }
  }
}