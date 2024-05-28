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
