resource "azurerm_log_analytics_workspace" "prod_monitoring" {
  name                = local.log_analytics_workspace_name
  location            = var.rg_location
  resource_group_name = var.tarot_cloud_rg_name
  sku                 = local.log_analytics_workspace_sku
  retention_in_days   = local.log_analytics_workspace_retention_in_days

  tags = {
    Environment = local.environment
  }
}

resource "azurerm_storage_account" "monitoring" {
  name                     = local.storage_account_name
  resource_group_name      = var.tarot_cloud_rg_name
  location                 = var.rg_location
  account_tier             = local.SA_account_tier
  account_replication_type = local.SA_account_replication_type

  min_tls_version = "TLS1_2"

  tags = {
    Environment = local.environment
  }
}

resource "azurerm_monitor_diagnostic_setting" "prod_monitoring" { # to be switched with azure monitor agent for linux machines, it is collecting more informations https://medium.com/@t.costantini89/send-linux-vm-logs-to-an-azure-log-analytics-workspace-using-terraform-and-the-azure-monitor-agent-939d481cc48a
  name                       = local.prod_monitoring_settings_name
  target_resource_id         = var.vm_id
  storage_account_id         = azurerm_storage_account.monitoring.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.prod_monitoring.id

  enabled_metric {
    category = "AllMetrics"
  }

  depends_on = [
    azurerm_storage_account.monitoring,
    azurerm_log_analytics_workspace.prod_monitoring
  ]
}

resource "azurerm_monitor_action_group" "alerts" {
  name                = local.prod_alerts
  resource_group_name = var.tarot_cloud_rg_name
  short_name          = local.prod_alerts

  email_receiver {
    name          = "email_address_for_monitoring"
    email_address = var.owner_email_address
  }
}

# CPU Alert
resource "azurerm_monitor_metric_alert" "cpu_alert" {
  name                = local.cpu_alert_name
  resource_group_name = var.tarot_cloud_rg_name
  scopes              = [var.vm_id]
  description         = local.cpu_alert_description
  severity            = var.alert_severity_cpu
  frequency           = local.frequency_of_metric_alerts
  window_size         = local.window_size_of_metric_alerts

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 90
  }

  action {
    action_group_id = azurerm_monitor_action_group.alerts.id
  }
}

# Memory Alert
resource "azurerm_monitor_metric_alert" "memory_alert" {
  name                = local.memory_alert_name
  resource_group_name = var.tarot_cloud_rg_name
  scopes              = [var.vm_id]
  description         = local.memory_alert_description
  severity            = var.alert_severity_memory
  frequency           = local.frequency_of_metric_alerts
  window_size         = local.window_size_of_metric_alerts

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Available Memory Bytes"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 0.1 * var.vm_memory_bytes
  }

  action {
    action_group_id = azurerm_monitor_action_group.alerts.id
  }
}
