provider "aws" {
  region = "eu-central-1"
}

provider "grafana" {
  auth = data.aws_ssm_parameter.grafana_sa_access_token.value
  url  = data.aws_ssm_parameter.grafana_url.value
}

provider "grafana" {
  alias           = "sm"
  sm_access_token = data.aws_ssm_parameter.grafana_sm_access_token.value
  sm_url          = data.aws_ssm_parameter.grafana_sm_api_url.value
}

terraform {
  backend "s3" {}
}
