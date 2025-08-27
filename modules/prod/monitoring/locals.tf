locals {
  environment                               = var.environment
  log_analytics_workspace_name              = "${var.environment}-monitoring-workspace"
  log_analytics_workspace_sku               = "PerGB2018"
  log_analytics_workspace_retention_in_days = 30
  prod_monitoring_settings_name             = "${var.environment}_monitoring_settings"
  prod_alerts                               = "prod-alerts" # the only thing that needed to be hardcoded cuz it accepts up to 12 letters

  frequency_of_metric_alerts   = "PT5M"
  window_size_of_metric_alerts = "PT5M"

  cpu_alert_name    = "${var.environment}-${var.vm_name}-cpu-alert"
  memory_alert_name = "${var.environment}-${var.vm_name}-memory-alert"

  cpu_alert_description    = "Alert if CPU usage exceeds 80% for 5 minutes"
  memory_alert_description = "Alert if Memory usage exceeds 80% for 5 minutes"
}
