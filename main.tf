locals {
  dashboard_files = fileset(path.module, "dashboards/*.json")
  dashboard_data = [for f in local.dashboard_files : {
    filename = f
    content  = (file(f))
    }
  ]

  alertrule_files             = fileset(path.module, "alertrules/*.json")
  data_sources_aws_athena     = fileset(path.module, "data_sources/aws_athena/*.json")
  data_sources_aws_cloudwatch = fileset(path.module, "data_sources/aws_cloudwatch/*.json")
}

# module "ce_folder" {
#   #checkov:skip=CKV_TF_1:We rely on release tags
#   source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_folder?ref=2.1.0"
#   #source = "../../../../../../terraform-grafana-cloud//grafana_folder" # Support for local development
#   title = var.folder_title
# }

# module "dashboards" {
#   #checkov:skip=CKV_TF_1:We rely on release tags
#   source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_dashboard?ref=2.1.0"
#   #source      = "../../../../../../terraform-grafana-cloud//grafana_dashboard" # Support for local development
#   folder      = module.ce_folder.id
#   config_json = local.dashboard_data
# }

# module "alerts" {
#   #checkov:skip=CKV_TF_1:We rely on release tags
#   source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_alert?ref=2.1.0"
#   # source          = "../../../../../../terraform-grafana-cloud//grafana_alert" # Support for local development
#   folder          = module.ce_folder.uid
#   alertrule_files = local.alertrule_files
# }

# module "grafana_data_source_aws_athena" {
#   #checkov:skip=CKV_TF_1:We rely on release tags
#   source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_data_source_athena?ref=2.1.0"
#   #source      = "../../../../../../terraform-grafana-cloud//grafana_data_source_athena" # Support for local development
#   data_sources = local.data_sources_aws_athena
# }

# module "grafana_data_source_aws_cloudwatch" {
#   #checkov:skip=CKV_TF_1:We rely on release tags
#   source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_data_source_cloudwatch?ref=2.1.0"
#   #source       = "../../../../../../terraform-grafana-cloud//grafana_data_source_cloudwatch" # Support for local development
#   data_sources = local.data_sources_aws_cloudwatch
# }

# module "grafana_notification" {
#   #checkov:skip=CKV_TF_1:We rely on release tags
#   source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_notification?ref=2.1.0"
#   #source               = "../../../../../../terraform-grafana-cloud//grafana_notification" # Support for local development
#   notification_enabled = true
#   name                 = "Cloud Engineering Slack"
#   slack_webhook_url    = var.notification_slack_webhook_url
#   policy_enabled       = true
#   policy_matcher = [{
#     label = "grafana_folder"
#     match = "="
#     value = "Cloud Engineering"
#   }]
# }



# Refactored modules testing

module "ce_folder" {
  count = var.enable_ce_folder ? 1 : 0
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_folder?ref=2.1.0"
  title  = var.folder_title
}

module "dashboards" {
  count = var.enable_dashboards && var.enable_ce_folder ? 1 : 0
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_dashboard?ref=2.1.0"
  folder = module.ce_folder[0].id
  config_json = local.dashboard_data
}

module "alerts" {
  count = var.enable_alerts && var.enable_ce_folder ? 1 : 0
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_alert?ref=2.1.0"
  folder = module.ce_folder[0].uid
  alertrule_files = local.alertrule_files
}

module "grafana_data_source_aws_athena" {
  count = var.enable_grafana_data_source_aws_athena ? 1 : 0
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_data_source_athena?ref=2.1.0"
  data_sources = local.data_sources_aws_athena
}

module "grafana_data_source_aws_cloudwatch" {
  count = var.enable_grafana_data_source_aws_cloudwatch ? 1 : 0
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_data_source_cloudwatch?ref=2.1.0"
  data_sources = local.data_sources_aws_cloudwatch
}

module "grafana_notification" {
  count = var.enable_grafana_notification ? 1 : 0
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_notification?ref=2.1.0"
  notification_enabled = true
  name                 = "Cloud Engineering Slack"
  slack_webhook_url    = var.notification_slack_webhook_url
  policy_enabled       = true
  policy_matcher = [{
    label = "grafana_folder"
    match = "="
    value = "Cloud Engineering"
  }]
}