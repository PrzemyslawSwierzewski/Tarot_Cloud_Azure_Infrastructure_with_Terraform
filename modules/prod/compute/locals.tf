locals {
  vm_size                   = "Standard_DC1ds_v3"
  os_disk_caching           = "ReadWrite"
  os_disk_storage_type      = "Standard_LRS"
  image_publisher           = "Canonical"
  image_offer               = "0001-com-ubuntu-server-jammy"
  image_sku                 = "22_04-lts-gen2"
  image_version             = "latest"# For production, it is recommended to pin to a specific image version instead of "latest"
  azure_monitor_linux_agent = "AzureMonitorLinuxAgent"
  tarot_cloud_nic_name      = "tarot-cloud-nic"
  vmss_instance_count       = 1
  environment               = "Production"
}
