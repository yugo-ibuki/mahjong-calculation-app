# Firestore モジュール
# データベース設定とインデックスを管理

# Firestore データベース
resource "google_firestore_database" "default" {
  provider        = google-beta
  project         = var.project_id
  name            = "(default)"
  location_id     = var.region
  type            = "FIRESTORE_NATIVE"
  deletion_policy = var.environment == "prod" ? "DELETE_PROTECTION_DISABLED" : "DELETE"

  # 既存のデータベースがある場合はインポートが必要
  lifecycle {
    prevent_destroy = false
  }
}

# インデックス: history コレクション (userId, createdAt)
resource "google_firestore_index" "history_user_created" {
  provider   = google-beta
  project    = var.project_id
  database   = google_firestore_database.default.name
  collection = "history"

  fields {
    field_path = "userId"
    order      = "ASCENDING"
  }

  fields {
    field_path = "createdAt"
    order      = "DESCENDING"
  }
}
