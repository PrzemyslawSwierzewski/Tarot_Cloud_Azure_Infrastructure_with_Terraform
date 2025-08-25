resource "azurerm_linux_virtual_machine" "tarot_cloud_linux_VM" {
  for_each = { for idx, nic in var.tarot_cloud_nic : idx => nic }

  name                  = "${local.vm_name}-${each.key}"
  resource_group_name   = var.tarot_cloud_rg_name
  location              = var.rg_location
  size                  = local.vm_size
  admin_username        = var.admin_username
  network_interface_ids = [each.value]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.env == "local" ? local.ssh_public_key_local : var.ssh_public_key
  }

  os_disk {
    caching              = local.os_disk_caching
    storage_account_type = local.os_disk_storage_type
  }

  source_image_reference {
    publisher = local.image_publisher
    offer     = local.image_offer
    sku       = local.image_sku
    version   = local.image_version
  }

  custom_data = base64encode(file("${path.module}/cloud-init.tpl"))
}