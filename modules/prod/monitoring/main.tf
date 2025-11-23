# Log Analytics Workspace
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

# Wait for workspace to be fully provisioned
resource "time_sleep" "wait_for_workspace" {
  depends_on      = [azurerm_log_analytics_workspace.prod_monitoring]
  create_duration = "30s"
}

# Data Collection Rule
resource "azurerm_monitor_data_collection_rule" "dcr" {
  depends_on          = [time_sleep.wait_for_workspace]
  name                = "dcr_${var.vmss_name}"
  resource_group_name = var.tarot_cloud_rg_name
  location            = var.rg_location

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.prod_monitoring.id
      name                  = "la-destination"
    }
  }

  data_sources {
    syslog {
      name           = "syslog-source"
      facility_names = ["auth", "daemon", "syslog"]
      log_levels     = ["Warning", "Error", "Critical", "Alert", "Emergency"]
      streams        = ["Microsoft-Syslog"]
    }
  }

  data_flow {
    streams      = ["Microsoft-Syslog"]
    destinations = ["la-destination"]
  }
}

# Diagnostic Setting
resource "azurerm_monitor_diagnostic_setting" "prod_monitoring" {
  depends_on                 = [azurerm_log_analytics_workspace.prod_monitoring]
  name                       = local.prod_monitoring_settings_name
  target_resource_id         = var.vmss_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.prod_monitoring.id

  enabled_metric {
    category = "AllMetrics"
  }
}

# DCR Association
resource "azurerm_monitor_data_collection_rule_association" "dcr_association" {
  depends_on              = [azurerm_monitor_data_collection_rule.dcr]
  name                    = "dcr_${var.vmss_name}_association"
  target_resource_id      = var.vmss_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr.id
  description             = "Association between the Data Collection Rule and the Linux VM."
}

# Action Group
resource "azurerm_monitor_action_group" "alerts" {
  name                = local.prod_alerts
  resource_group_name = var.tarot_cloud_rg_name
  short_name          = local.prod_alerts

  email_receiver {
    name          = "email_address_for_monitoring"
    email_address = var.owner_email_address
  }
}

# VM Availability Alert
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "vm_availability_alert" {
  depends_on           = [azurerm_log_analytics_workspace.prod_monitoring]
  name                 = "vm_availability_alert_${var.vmss_name}"
  resource_group_name  = var.tarot_cloud_rg_name
  location             = var.rg_location
  description          = "Alert if Linux VM becomes unavailable"
  severity             = 1
  enabled              = true
  window_duration      = local.window_size_of_metric_alerts
  evaluation_frequency = local.frequency_of_metric_alerts

  scopes = [var.vmss_id]

  criteria {
    query = <<KQL
AzureMetrics
| where MetricName == "VmAvailabilityMetric"
| where ResourceId == toupper("${var.vmss_id}")
| summarize LatestTotal = arg_max(TimeGenerated, Total)
KQL

    time_aggregation_method = "Minimum"
    metric_measure_column   = "Total"
    operator                = "LessThan"
    threshold               = 1
  }

  action {
    action_groups = [azurerm_monitor_action_group.alerts.id]
  }
}

# CPU Alert
resource "azurerm_monitor_metric_alert" "cpu_alert" {
  name                = local.cpu_alert_name
  resource_group_name = var.tarot_cloud_rg_name
  scopes              = [var.vmss_id]
  description         = local.cpu_alert_description
  severity            = var.alert_severity_cpu
  frequency           = local.frequency_of_metric_alerts
  window_size         = local.window_size_of_metric_alerts

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.alerts.id
  }
}

# Memory Alert
resource "azurerm_monitor_metric_alert" "memory_alert" {
  name                = local.memory_alert_name
  resource_group_name = var.tarot_cloud_rg_name
  scopes              = [var.vmss_id]
  description         = local.memory_alert_description
  severity            = var.alert_severity_memory
  frequency           = local.frequency_of_metric_alerts
  window_size         = local.window_size_of_metric_alerts

  criteria {
    metric_namespace = "Azure.VM.Linux.GuestMetrics"
    metric_name      = "Available Memory %"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 10
  }

  action {
    action_group_id = azurerm_monitor_action_group.alerts.id
  }
}
