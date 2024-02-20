provider "aws" {
  region = "eu-central-1"
}

provider "grafana" {
  auth = data.aws_ssm_parameter.grafana_sa_access_token.value
  url  = data.aws_ssm_parameter.grafana_url.value
}

terraform {
  backend "s3" {}
}
