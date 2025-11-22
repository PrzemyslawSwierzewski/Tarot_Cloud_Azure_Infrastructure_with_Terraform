resource "azurerm_linux_virtual_machine_scale_set" "tarot_cloud_linux_vmss" {
  name                = "${var.vm_name}-${local.environment}"
  resource_group_name = var.tarot_cloud_rg_name
  location            = var.rg_location
  sku                 = local.vm_size
  instances           = local.vmss_instance_count
  admin_username      = var.admin_username

  custom_data = base64encode(file("${path.module}/cloud-init.tpl"))

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  source_image_reference {
    publisher = local.image_publisher
    offer     = local.image_offer
    sku       = local.image_sku
    version   = local.image_version
  }

  os_disk {
    caching              = local.os_disk_caching
    storage_account_type = local.os_disk_storage_type
  }

  network_interface {
    name    = "${local.tarot_cloud_nic_name}-${local.environment}"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = var.subnet_id
      load_balancer_backend_address_pool_ids = var.backend_pool_ids
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = local.environment
  }
}

resource "azurerm_virtual_machine_scale_set_extension" "ama_linux" {
  name                         = local.azure_monitor_linux_agent
  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.tarot_cloud_linux_vmss.id
  publisher                    = "Microsoft.Azure.Monitor"
  type                         = local.azure_monitor_linux_agent
  type_handler_version         = var.type_handler_version
  auto_upgrade_minor_version   = true
}

resource "azurerm_monitor_autoscale_setting" "vmss_autoscale" {
  name                = "tarot-cloud-autoscale"
  resource_group_name = var.tarot_cloud_rg_name
  location            = var.rg_location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.tarot_cloud_linux_vmss.id
  profile {
    name = "default"

    capacity {
      minimum = 1
      maximum = 5
      default = 1
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.tarot_cloud_linux_vmss.id
        operator           = "GreaterThan"
        threshold          = 70
        aggregation        = "Average"
        duration           = "PT5M"
      }

      scale_action {
        type     = "Increase"
        value    = "1"
        cooldown = "PT5M"
      }
    }
  }
}
