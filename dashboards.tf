locals {
  json_files = fileset(path.module, "dashboards/*.json")
  json_data = [for f in local.json_files : {
    filename = f
    content  = (file(f))
    }
  ]
}

module "dashboards" {
  source      = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_dashboard?ref=0.2.0"
  folder      = module.ce_folder.id
  config_json = local.json_data
}
