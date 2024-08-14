output "dashboard_meta" {
  value = length(module.dashboards) > 0 ? module.dashboards[0].meta : null
}
