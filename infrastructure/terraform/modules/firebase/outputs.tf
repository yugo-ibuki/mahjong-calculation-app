output "web_app_id" {
  description = "Firebase Web App ID"
  value       = google_firebase_web_app.web.app_id
}

output "firebase_config" {
  description = "Firebase configuration for web app"
  value = {
    api_key             = data.google_firebase_web_app_config.web.api_key
    auth_domain         = data.google_firebase_web_app_config.web.auth_domain
    project_id          = var.project_id
    storage_bucket      = data.google_firebase_web_app_config.web.storage_bucket
    messaging_sender_id = data.google_firebase_web_app_config.web.messaging_sender_id
    app_id              = google_firebase_web_app.web.app_id
  }
  sensitive = true
}
