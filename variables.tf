variable "grafana_auth" {
  type        = string
  sensitive   = true
  description = "API key for a Grafana Cloud serviceaccount"
}

variable "grafana_url" {
  type        = string
  description = "The URL to a Grafana Cloud stack"
}

variable "folder_title" {
  type        = string
  default     = "Cloud Engineering"
  description = "Folder title"
}

variable "environment" {
  type        = string
  description = "The environment to deploy to"
}
