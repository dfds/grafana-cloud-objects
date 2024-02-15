provider "grafana" {
  auth = var.grafana_auth
  url  = var.grafana_url
}

provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {}
}
