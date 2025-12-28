# 初期はローカル状態を使用
# GCS バックエンドに移行する場合は以下をコメント解除

# terraform {
#   backend "gcs" {
#     bucket = "mahjong-calculation-app-terraform-state"
#     prefix = "terraform/state/dev"
#   }
# }
