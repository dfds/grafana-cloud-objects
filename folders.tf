module "ce_folder" {
  source = "git::https://github.com/dfds/terraform-grafana-cloud.git//grafana_folder?ref=0.2.0"
  title  = var.folder_title
}
