provider "grafana" {
  auth = var.grafana_auth
  url  = var.grafana_url
}

terraform {
  backend "s3" {}
}
