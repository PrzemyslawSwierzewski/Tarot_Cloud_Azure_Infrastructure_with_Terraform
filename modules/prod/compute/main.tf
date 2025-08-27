resource "azurerm_linux_virtual_machine" "tarot_cloud_linux_vm" {
  name                  = "${var.vm_name}-${var.environment}"
  resource_group_name   = var.tarot_cloud_rg_name
  location              = var.rg_location
  size                  = local.vm_size
  admin_username        = var.admin_username
  network_interface_ids = var.tarot_cloud_nic

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
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

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_virtual_machine_extension" "ama_linux" {
  name                       = local.azure_monitor_linux_agent
  virtual_machine_id         = azurerm_linux_virtual_machine.tarot_cloud_linux_vm.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = local.azure_monitor_linux_agent
  type_handler_version       = var.type_handler_version
  auto_upgrade_minor_version = true
}
