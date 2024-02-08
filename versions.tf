terraform {
  required_version = ">= 1.3.0, < 1.6.0"

  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = ">= 2.9.0"
    }
  }
}
