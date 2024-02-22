locals {
  dashboard_files = fileset(path.module, "dashboards/*.json")
  dashboard_data = [for f in local.dashboard_files : {
    filename = f
    content  = (file(f))
    }
  ]

  alertrule_files = fileset(path.module, "alertrules/*.json")

  synthetic_files = fileset(path.module, "synthetics/${var.environment}/*.json")

}

module "ce_folder" {
  #checkov:skip=CKV_TF_1:We rely on release tags
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_folder?ref=0.10.0"
  #source = "../../../../../../terraform-grafana-cloud//grafana_folder" # Support for local development
  title = var.folder_title
}



module "dashboards" {
  #checkov:skip=CKV_TF_1:We rely on release tags
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_dashboard?ref=0.10.0"
  #source      = "../../../../../../terraform-grafana-cloud//grafana_dashboard" # Support for local development
  folder      = module.ce_folder.id
  config_json = local.dashboard_data
}


module "alerts" {
  #checkov:skip=CKV_TF_1:We rely on release tags
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_alert?ref=0.10.0"
  # source          = "../../../../../../terraform-grafana-cloud//grafana_alert" # Support for local development
  folder          = module.ce_folder.uid
  alertrule_files = local.alertrule_files
}

module "synthetic_checks" {
  #checkov:skip=CKV_TF_1:We rely on release tags
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_synthetic_check?ref=0.10.0"
  #source          = "../../../../../../terraform-grafana-cloud//grafana_synthetic_check" # Support for local development
  synthetic_files  = local.synthetic_files
  basic_auth       = var.synthetic_basic_auth
  bearer_token     = var.synthetic_bearer_token
  synthetic_probes = var.synthetic_probes

  providers = {
    grafana = grafana.sm
  }
}
