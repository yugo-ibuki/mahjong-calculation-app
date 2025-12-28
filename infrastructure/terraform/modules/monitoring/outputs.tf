output "notification_channel_id" {
  description = "Email notification channel ID"
  value       = google_monitoring_notification_channel.email.id
}

output "error_alert_policy_id" {
  description = "Error rate alert policy ID"
  value       = google_monitoring_alert_policy.function_errors.id
}

output "latency_alert_policy_id" {
  description = "Latency alert policy ID"
  value       = google_monitoring_alert_policy.function_latency.id
}
