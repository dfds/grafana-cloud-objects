variable "environment" {
  type        = string
  description = "Environment"
}

variable "folder_title" {
  type        = string
  default     = "Cloud Engineering"
  description = "Folder title"
}

variable "notification_slack_webhook_url" {
  type        = string
  default     = ""
  description = "Slack webhook URL."
  sensitive   = true
}

variable "enable_ce_folder" {
  type        = bool
  default     = true
  description = "Enable the ce_folder module."
}

variable "enable_dashboards" {
  type        = bool
  default     = true
  description = "Enable the dashboards module."
}

variable "enable_alerts" {
  type        = bool
  default     = true
  description = "Enable the alerts module."
}

variable "enable_grafana_data_source_aws_athena" {
  type        = bool
  default     = true
  description = "Enable the Grafana AWS Athena data source module."
}

variable "enable_grafana_data_source_aws_cloudwatch" {
  type        = bool
  default     = true
  description = "Enable the Grafana AWS Cloudwatch data source module."
}

variable "enable_grafana_notification" {
  type        = bool
  default     = true
  description = "Enable the Grafana notification module."
}
