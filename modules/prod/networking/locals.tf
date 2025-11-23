locals {
  resource_group_name = "Tarot-cloud"
  resources_location  = "East US"
  vnet = {
    vnet1 = {
      address_space = "10.0.0.0/16",
      subnet_prefix = "10.0.1.0/24"
    }
  }
  tarot_cloud_subnet_name  = "tarot-cloud-subnet"
  tarot_cloud_network_name = "tarot-cloud-network"
  public_ip_name           = "tarot-cloud-public-ip"
  load_balancer_name       = "tarot-cloud-lb"
  backend_pool_name        = "tarot-cloud-backend-pool"
  lb_probe_name            = "http-probe"
  lb_rule_name             = "http-rule"
  environment              = "production"
}