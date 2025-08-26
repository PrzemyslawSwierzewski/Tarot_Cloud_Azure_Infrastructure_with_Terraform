output "tarot_cloud_public_ip_prod" {
  value = module.prod_networking.tarot_cloud_public_ip
}

output "tarot_cloud_public_ip_dev" {
  value = module.dev_networking.tarot_cloud_public_ip
}