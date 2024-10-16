data "aws_ssm_parameter" "grafana_url" {
  name = "/grafana-cloud/${var.environment}/stack-url"
}

data "aws_ssm_parameter" "grafana_sa_access_token" {
  name = "/grafana-cloud/${var.environment}/terraform-sa-access-token"
}

data "aws_ssm_parameter" "prometheus_rules_management_token" {
  name = "/grafana-cloud/${var.environment}/rules-management-access-token"
}

data "aws_ssm_parameter" "prometheus_url" {
  name = "/grafana-cloud/${var.environment}/prometheus-url"
}

data "aws_ssm_parameter" "prometheus_user_id" {
  name = "/grafana-cloud/${var.environment}/prometheus-user-id"
}
