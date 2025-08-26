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

resource "azurerm_storage_container" "monitoring_container" {
  name                  = "monitoringcontainer"
  storage_account_id    = azurerm_storage_account.monitoring.id
  container_access_type = "container"
}

resource "azurerm_monitor_data_collection_rule" "dcr" {
  name                = "dcr_linux"
  resource_group_name = var.tarot_cloud_rg_name
  location            = var.rg_location
  kind                = "Linux"

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.prod_monitoring.id
      name                  = "destination-log"
    }

    storage_blob {
      storage_account_id = azurerm_storage_account.monitoring.id
      container_name     = azurerm_storage_container.monitoring_container.name
      name               = "example-destination-storage"
    }
  }

  data_flow {
    streams      = ["Microsoft-Syslog"]
    destinations = ["destination-log"]
  }

  data_sources {
    syslog {
      facility_names = ["daemon", "syslog"]
      log_levels     = ["Warning", "Error", "Critical", "Alert", "Emergency"]
      name           = "datasource-syslog"
      streams        = ["destination-log"]
    }
  }
}

resource "azurerm_monitor_data_collection_rule_association" "dcr_association" {
  name                    = "DCR-VM-Association"
  target_resource_id      = var.vm_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr.id
  description             = "Association between the Data Collection Rule and the Linux VM."
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "heartbeat_alert" {
  name                 = "vm_heartbeat_alert"
  resource_group_name  = var.tarot_cloud_rg_name
  location             = var.rg_location
  description          = "Alert if Linux VM stops sending heartbeat"
  severity             = 1
  enabled              = true
  window_duration      = local.window_size_of_metric_alerts # Check last 5 minutes
  evaluation_frequency = local.frequency_of_metric_alerts   # Evaluate every 1 minute

  scopes = [azurerm_log_analytics_workspace.prod_monitoring.id]

  criteria {
    query = <<KQL
  Heartbeat
  | where Computer == "${var.vm_name}"
  | summarize LastHeartbeat = max(TimeGenerated)
  | extend MinutesSinceLast = datetime_diff('minute', now(), LastHeartbeat)
  | where MinutesSinceLast > 5
  KQL

    time_aggregation_method = "Average"
    operator                = "GreaterThan"
    threshold               = 0
  }

  action {
    action_groups = [azurerm_monitor_action_group.alerts.id]
  }
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
