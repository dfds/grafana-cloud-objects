output "dashboard_meta" {
  value = var.enable_dashboards && var.enable_ce_folder ? module.dashboards[0].meta : null
}
