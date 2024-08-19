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
  description = "Enable the CE Folder module."
}

variable "enable_dashboards" {
  type        = bool
  default     = true
  description = "Enable the Dashboards module."
}

variable "enable_alerts" {
  type        = bool
  default     = true
  description = "Enable the Alerts module."
}

variable "enable_grafana_data_source_aws_athena" {
  type        = bool
  default     = true
  description = "Enable the Grafana AWS Athena Data Source module."
}

variable "enable_grafana_data_source_aws_cloudwatch" {
  type        = bool
  default     = true
  description = "Enable the Grafana AWS CloudWatch Data Source module."
}

variable "enable_grafana_notification" {
  type        = bool
  default     = false
  description = "Enable the Grafana Notification module."
}
