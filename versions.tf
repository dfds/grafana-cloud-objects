terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.11"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "~> 4.5"
    }
  }
}
