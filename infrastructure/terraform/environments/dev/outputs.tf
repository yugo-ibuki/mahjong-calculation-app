output "firebase_web_app_id" {
  description = "Firebase Web App ID"
  value       = module.firebase.web_app_id
}

output "firestore_database_name" {
  description = "Firestore database name"
  value       = module.firestore.database_name
}
