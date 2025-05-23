locals {
  dashboard_files = fileset(path.module, "dashboards/*.json")
  dashboard_data = [for f in local.dashboard_files : {
    filename = f
    content  = (file(f))
  }]

  alertrule_files             = fileset(path.module, "alertrules/*.json")
  data_sources_aws_athena     = fileset(path.module, "data_sources/aws_athena/*.json")
  data_sources_aws_cloudwatch = fileset(path.module, "data_sources/aws_cloudwatch/*.json")
  data_sources_infinity       = fileset(path.module, "data_sources/infinity/*.json")
  prometheus_rule_files       = fileset(path.module, "prometheus_rules/*.yaml")
}

module "ce_folder" {
  count  = var.enable_ce_folder ? 1 : 0
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_folder?ref=2.12.0"
  #source = "../../../../../../terraform-grafana-cloud//grafana_folder" # Support for local development
  #checkov:skip=CKV_TF_1:We rely on release tags
  title = var.folder_title
}

module "dashboards" {
  count  = var.enable_dashboards && var.enable_ce_folder ? 1 : 0
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_dashboard?ref=2.12.0"
  #source = "../../../../../../terraform-grafana-cloud//grafana_dashboard" # Support for local development
  #checkov:skip=CKV_TF_1:We rely on release tags
  folder      = module.ce_folder[0].id
  config_json = local.dashboard_data
}

module "alerts" {
  count  = var.enable_alerts && var.enable_ce_folder ? 1 : 0
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_alert?ref=2.12.0"
  #source = "../../../../../../terraform-grafana-cloud//grafana_alert" # Support for local development
  #checkov:skip=CKV_TF_1:We rely on release tags
  folder          = module.ce_folder[0].uid
  alertrule_files = local.alertrule_files
}

module "grafana_data_source_aws_athena" {
  count  = var.enable_grafana_data_source_aws_athena ? 1 : 0
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_data_source_athena?ref=2.12.0"
  #source = "../../../../../../terraform-grafana-cloud//grafana_data_source_athena" # Support for local development
  #checkov:skip=CKV_TF_1:We rely on release tags
  data_sources   = local.data_sources_aws_athena
  grafana_url    = data.aws_ssm_parameter.grafana_url.value
  bearer_token   = data.aws_ssm_parameter.grafana_sa_access_token.value
  enable_caching = true
}

module "grafana_data_source_aws_cloudwatch" {
  count  = var.enable_grafana_data_source_aws_cloudwatch ? 1 : 0
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_data_source_cloudwatch?ref=2.12.0"
  #source = "../../../../../../terraform-grafana-cloud//grafana_data_source_cloudwatch" # Support for local development
  #checkov:skip=CKV_TF_1:We rely on release tags
  data_sources = local.data_sources_aws_cloudwatch
}

module "grafana_data_source_infinity" {
  count  = var.enable_grafana_data_source_infinity ? 1 : 0
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_data_source_infinity?ref=2.12.0"
  #source = "../../../../../../terraform-grafana-cloud//grafana_data_source_infinity" # Support for local development
  #checkov:skip=CKV_TF_1:We rely on release tags
  bearer_token = var.infinity_bearer_token
  data_sources = local.data_sources_infinity
}

module "grafana_notification" {
  count  = var.enable_grafana_notification ? 1 : 0
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_notification?ref=2.12.0"
  #source = "../../../../../../terraform-grafana-cloud//grafana_notification" # Support for local development
  #checkov:skip=CKV_TF_1:We rely on release tags
  notification_enabled = true
  name                 = "Cloud Engineering Slack"
  slack_webhook_url    = var.notification_slack_webhook_url
  policy_enabled       = true
  policy_matcher = [{
    label = "grafana_folder"
    match = "="
    value = "Cloud Engineering"
  }]
  additional_policies = [
    {
      contact_point = "Cloud Engineering - SSU Slack"
      group_by = ["grafana_folder"]
      repeat_interval = "24h"
      matcher = [
        {
          label = "grafana_folder"
          match = "="
          value = "Cloud Engineering - SSU"
        }]
    }
  ]
}

module "prometheus_rules" {
  count  = var.enable_prometheus_rules ? 1 : 0
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_prometheus_rules?ref=2.12.0"
  #source = "../../../../../../terraform-grafana-cloud//grafana_prometheus_rules" # Support for local development
  #checkov:skip=CKV_TF_1:We rely on release tags
  prometheus_rule_files         = local.prometheus_rule_files
  prometheus_url                = data.aws_ssm_parameter.prometheus_url.value
  prometheus_user_id            = data.aws_ssm_parameter.prometheus_user_id.value
  rules_management_access_token = data.aws_ssm_parameter.prometheus_rules_management_token.value
}

moved {
  from = module.ce_folder
  to   = module.ce_folder[0]
}

moved {
  from = module.dashboards
  to   = module.dashboards[0]
}

moved {
  from = module.alerts
  to   = module.alerts[0]
}

moved {
  from = module.grafana_data_source_aws_athena
  to   = module.grafana_data_source_aws_athena[0]
}

moved {
  from = module.grafana_data_source_aws_cloudwatch
  to   = module.grafana_data_source_aws_cloudwatch[0]
}

moved {
  from = module.grafana_notification
  to   = module.grafana_notification[0]
}
