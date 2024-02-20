data "aws_ssm_parameter" "grafana_url" {
  name = "/grafana-cloud/${var.environment}/stack-url"
}

data "aws_ssm_parameter" "grafana_sa_access_token" {
  name = "/grafana-cloud/${var.environment}/terraform-sa-access-token"
}

