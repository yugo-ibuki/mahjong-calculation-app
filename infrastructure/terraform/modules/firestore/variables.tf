variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region (Firestore location)"
  type        = string
  default     = "asia-northeast1"
}

variable "environment" {
  description = "Environment (dev/prod)"
  type        = string
}
