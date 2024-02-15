locals {
  json_files = fileset(path.module, "dashboards/*.json")
  json_data = [for f in local.json_files : {
    filename = f
    content  = (file(f))
    }
  ]

  alertrule_files = fileset(path.module, "alertrules/*.json")
}

module "ce_folder" {
  #checkov:skip=CKV_TF_1:We rely on release tags
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_folder?ref=0.6.1"
  #source = "../../../../../../terraform-grafana-cloud//grafana_folder" # Support for local development
  title = var.folder_title
}



module "dashboards" {
  #checkov:skip=CKV_TF_1:We rely on release tags
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_dashboard?ref=0.6.1"
  #source      = "../../../../../../terraform-grafana-cloud//grafana_dashboard" # Support for local development
  folder      = module.ce_folder.id
  config_json = local.json_data
}


module "alerts" {
  #checkov:skip=CKV_TF_1:We rely on release tags
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_alert?ref=0.6.1"
  # source          = "../../../../../../terraform-grafana-cloud//grafana_alert" # Support for local development
  folder          = module.ce_folder.uid
  alertrule_files = local.alertrule_files
}

data "aws_ssm_parameter" "sm_url" {
  name = "/grafana-cloud/${var.environment}/sm-api-url"
}

data "aws_ssm_parameter" "sm_token" {
  name = "/grafana-cloud/${var.environment}/sm-access-token"
}

provider "grafana" {
  alias           = "sm"
  sm_access_token = data.aws_ssm_parameter.sm_token.value
  sm_url          = data.aws_ssm_parameter.sm_url.value
}

module "checks" {
  source = "../../../../../../terraform-grafana-cloud//grafana_synthetic_check"
  #checkov:skip=CKV_TF_1:We rely on release tags
  job    = "1Password SCIM Bridge"
  target = "https://1password.hellman.oxygen.dfds.cloud/app"
  labels = {
    App = "1Password"
  }
  http_check_settings = {
    method             = "GET"
    valid_status_codes = [200]
  }

  providers = {
    grafana = grafana.sm
  }
}

output "dashboard_meta" {
  value = module.dashboards.meta
}
