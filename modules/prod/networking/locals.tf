locals {
  resource_group_name = "Tarot-cloud"
  resources_location  = "Canada Central"
  vnet = {
    vnet1 = {
      address_space          = "10.0.0.0/16",
      subnet_prefix_vmss     = "10.0.1.0/24"
      subnet_prefix_postgres = "10.0.2.0/24"
    }
  }
  vmss_subnet_name               = "vmss-subnet"
  postgres_subnet_name           = "postgres-subnet"
  tarot_cloud_network_name       = "tarot-cloud-network"
  public_ip_name                 = "tarot-cloud-public-ip"
  load_balancer_name             = "tarot-cloud-lb"
  backend_pool_name              = "tarot-cloud-backend-pool"
  lb_probe_name                  = "http-probe"
  lb_rule_name                   = "http-rule"
  environment                    = "production"
  postgres_private_dns_zone_name = "privatelink.postgres.database.azure.com"
}