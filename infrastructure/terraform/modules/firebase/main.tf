# Firebase モジュール
# App Check 設定と Web アプリ登録を管理

# 既存の Firebase プロジェクトを参照
data "google_project" "main" {
  project_id = var.project_id
}

# Firebase プロジェクト有効化
resource "google_firebase_project" "default" {
  provider = google-beta
  project  = var.project_id
}

# App Check - Cloud Functions の設定
resource "google_firebase_app_check_service_config" "functions" {
  provider         = google-beta
  project          = var.project_id
  service_id       = "firebasefunctions.googleapis.com"
  enforcement_mode = var.environment == "prod" ? "ENFORCED" : "UNENFORCED"

  depends_on = [google_firebase_project.default]
}

# Web アプリ登録
resource "google_firebase_web_app" "web" {
  provider     = google-beta
  project      = var.project_id
  display_name = "Mahjong Calculator Web"

  depends_on = [google_firebase_project.default]
}

# Web アプリの設定情報を取得
data "google_firebase_web_app_config" "web" {
  provider   = google-beta
  project    = var.project_id
  web_app_id = google_firebase_web_app.web.app_id
}
