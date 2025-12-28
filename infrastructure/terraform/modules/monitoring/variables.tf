variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "environment" {
  description = "Environment (dev/prod)"
  type        = string
}

variable "alert_email" {
  description = "Email address for alert notifications"
  type        = string
}
