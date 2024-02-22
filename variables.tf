variable "environment" {
  type        = string
  description = "Environment"
}

variable "folder_title" {
  type        = string
  default     = "Cloud Engineering"
  description = "Folder title"
}

variable "synthetic_bearer_token" {
  description = <<EOF
    Map of bearer tokens for the synthetic monitoring targets.
    The keys are the synthetic target names and the values are the bearer tokens.
    Should never be stored in plain text, but should come from a secret manager.
  EOF
  type        = map(string)
  sensitive   = true
  default     = {}
}

variable "synthetic_basic_auth" {
  description = <<EOF
    List of username and password combinations for any basic authentication required for the synthetic monitoring targets.
    The keys are the synthetic target names and the values are new maps of username and password combinations.
    Should never be stored in plain text, but should come from a secret manager.
  EOF
  type        = map(map(string))
  sensitive   = true
  default     = {}
}

variable "synthetic_probes" {
  description = <<EOF
    List of synthetic monitoring probes to use for the synthetic monitoring targets.
  EOF
  type        = list(string)
  default     = ["Frankfurt", "London"]
}
