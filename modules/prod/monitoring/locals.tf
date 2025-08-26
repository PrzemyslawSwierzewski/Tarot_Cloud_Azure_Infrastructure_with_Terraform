locals {
  # Environment & naming
  environment                               = "prod"
  log_analytics_workspace_name              = "prod-monitoring-workspace"
  log_analytics_workspace_sku               = "PerGB2018"
  log_analytics_workspace_retention_in_days = 30
  SA_account_tier                           = "Standard"
  storage_account_name                      = "storageaccountforprodmon"
  SA_account_replication_type               = "LRS"
  prod_monitoring_settings_name             = "prod_monitoring_settings"
  prod_alerts                               = "prod_alerts"

  # Metric alert defaults
  frequency_of_metric_alerts   = "PT1M"
  window_size_of_metric_alerts = "PT5M"

  # CPU / memory alerts
  cpu_alert_name    = "${local.environment}-${var.vm_name}-cpu-alert"
  memory_alert_name = "${local.environment}-${var.vm_name}-memory-alert"

  # Alert descriptions
  cpu_alert_description    = "Alert if CPU usage exceeds 80% for 5 minutes"
  memory_alert_description = "Alert if Memory usage exceeds 80% for 5 minutes"
}
