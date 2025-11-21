locals {
  vm_size              = "Standard_b1s"
  os_disk_caching      = "ReadWrite"
  os_disk_storage_type = "Standard_LRS"
  image_publisher      = "Canonical"
  image_offer          = "0001-com-ubuntu-server-jammy"
  image_sku            = "22_04-lts"
  image_version        = "latest"
}
