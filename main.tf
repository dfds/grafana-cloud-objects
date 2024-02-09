# locals {
#   json_files = fileset(path.module, "dashboards/*.json")
#   json_data = [for f in local.json_files : {
#     filename = f
#     content  = (file(f))
#     }
#   ]
# }

locals { # For a single group
  alertrule_files = fileset(path.module, "alertrules/*.json")
}

module "ce_folder" {
  #checkov:skip=CKV_TF_1:We rely on release tags
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_folder?ref=0.3.2"
  #source = "../../../../../../terraform-grafana-cloud//grafana_folder" # Support for local development
  title = var.folder_title
}



# module "dashboards" {
#   #checkov:skip=CKV_TF_1:We rely on release tags
#   source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_dashboard?ref=0.3.2"
#   #source      = "../../../../../../terraform-grafana-cloud//grafana_dashboard" # Support for local development
#   folder      = module.ce_folder.id
#   config_json = local.json_data
# }


module "alerts" {
  #checkov:skip=CKV_TF_1:We rely on release tags
  # source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_dashboard?ref=0.3.2"
  source          = "../terraform-grafana-cloud//grafana_alert" # Support for local development
  folder          = module.ce_folder.uid
  alertrule_files = local.alertrule_files
}

# output "dashboard_meta" {
#   value = module.dashboards.meta
# }
