# Monitoring モジュール
# アラートと通知チャンネルを管理

# 通知チャンネル (Email)
resource "google_monitoring_notification_channel" "email" {
  project      = var.project_id
  display_name = "Email Alerts - ${var.environment}"
  type         = "email"

  labels = {
    email_address = var.alert_email
  }
}

# アラートポリシー: Cloud Functions エラー率
resource "google_monitoring_alert_policy" "function_errors" {
  project      = var.project_id
  display_name = "Cloud Functions Error Rate - ${var.environment}"
  combiner     = "OR"

  conditions {
    display_name = "Error rate > 1%"

    condition_threshold {
      filter          = "resource.type=\"cloud_run_revision\" AND metric.type=\"run.googleapis.com/request_count\" AND metric.labels.response_code_class!=\"2xx\""
      duration        = "300s"
      threshold_value = 0.01
      comparison      = "COMPARISON_GT"

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.name]

  alert_strategy {
    auto_close = "1800s"
  }
}

# アラートポリシー: Cloud Functions レイテンシ
resource "google_monitoring_alert_policy" "function_latency" {
  project      = var.project_id
  display_name = "Cloud Functions High Latency - ${var.environment}"
  combiner     = "OR"

  conditions {
    display_name = "p99 Latency > 2s"

    condition_threshold {
      filter          = "resource.type=\"cloud_run_revision\" AND metric.type=\"run.googleapis.com/request_latencies\""
      duration        = "300s"
      threshold_value = 2000
      comparison      = "COMPARISON_GT"

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_PERCENTILE_99"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.name]
}
