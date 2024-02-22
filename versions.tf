terraform {
  required_version = "< 1.7.5"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.34.0"
    }
    grafana = {
      source  = "grafana/grafana"
      version = ">= 2.9.0"
    }
  }
}
