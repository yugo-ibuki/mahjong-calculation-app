output "database_name" {
  description = "Firestore database name"
  value       = google_firestore_database.default.name
}

output "database_id" {
  description = "Firestore database ID"
  value       = google_firestore_database.default.id
}
