locals {
  dashboard_files = fileset(path.module, "dashboards/*.json")
  dashboard_data = [for f in local.dashboard_files : {
    filename = f
    content  = (file(f))
    }
  ]

  alertrule_files             = fileset(path.module, "alertrules/*.json")
  synthetic_files             = fileset(path.module, "synthetics/${var.environment}/*.json")
  data_sources_aws_athena     = fileset(path.module, "data_sources/aws_athena/*.json")
  data_sources_aws_cloudwatch = fileset(path.module, "data_sources/aws_cloudwatch/*.json")
}

module "ce_folder" {
  #checkov:skip=CKV_TF_1:We rely on release tags
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_folder?ref=0.12.0"
  #source = "../../../../../../terraform-grafana-cloud//grafana_folder" # Support for local development
  title = var.folder_title
}

module "dashboards" {
  #checkov:skip=CKV_TF_1:We rely on release tags
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_dashboard?ref=0.12.0"
  #source      = "../../../../../../terraform-grafana-cloud//grafana_dashboard" # Support for local development
  folder      = module.ce_folder.id
  config_json = local.dashboard_data
}

module "alerts" {
  #checkov:skip=CKV_TF_1:We rely on release tags
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_alert?ref=0.12.0"
  # source          = "../../../../../../terraform-grafana-cloud//grafana_alert" # Support for local development
  folder          = module.ce_folder.uid
  alertrule_files = local.alertrule_files
}

module "synthetic_checks" {
  #checkov:skip=CKV_TF_1:We rely on release tags
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_synthetic_check?ref=0.12.0"
  #source          = "../../../../../../terraform-grafana-cloud//grafana_synthetic_check" # Support for local development
  synthetic_files  = local.synthetic_files
  basic_auth       = var.synthetic_basic_auth
  bearer_token     = var.synthetic_bearer_token
  synthetic_probes = var.synthetic_probes

  providers = {
    grafana = grafana.sm
  }
}

module "grafana_data_source_aws_athena" {
  #checkov:skip=CKV_TF_1:We rely on release tags
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_data_source_athena?ref=0.13.0"
  #source      = "../../../../../../terraform-grafana-cloud//grafana_data_source_athena" # Support for local development
  data_sources = local.data_sources_aws_athena
}

module "grafana_data_source_aws_cloudwatch" {
  #checkov:skip=CKV_TF_1:We rely on release tags
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_data_source_cloudwatch?ref=0.13.0"
  #source       = "../../../../../../terraform-grafana-cloud//grafana_data_source_cloudwatch" # Support for local development
  data_sources = local.data_sources_aws_cloudwatch
}

module "grafana_data_source_loki" {
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_data_source_loki?ref=0.13.0"
  #source = "../../../../../../terraform-grafana-cloud//grafana_data_source_loki" # Support for local development
  data_sources = local.data_sources_loki
}

module "grafana_data_source_prometheus" {
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_data_source_prometheus?ref=0.13.0"
  #source = "../../../../../../terraform-grafana-cloud//grafana_data_source_prometheus" # Support for local development
  data_sources = local.data_sources_prometheus
}

module "grafana_data_source_tempo" {
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_data_source_tempo?ref=0.13.0"
  #source = "../../../../../../terraform-grafana-cloud//grafana_data_source_tempo" # Support for local development
  data_sources = local.data_sources_tempo
}
