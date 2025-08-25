locals {
  vm_name              = "tarot-cloud-vm"
  ssh_public_key_local = file("~/.ssh/id_rsa.pub")
  vm_size              = "Standard_F2"
  os_disk_caching      = "ReadWrite"
  os_disk_storage_type  = "Standard_LRS"
  image_publisher       = "Canonical"
  image_offer           = "0001-com-ubuntu-server-jammy"
  image_sku             = "22_04-lts"
  image_version         = "latest"
}
